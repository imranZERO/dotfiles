local M = {}

local default_opts = {
	height_proportion = 0.8,
	width_proportion = 0.8,
	height = function(self) return math.floor(vim.o.lines * self.height_proportion) end,
	width = function(self) return math.floor(vim.o.columns * self.width_proportion) end,
	row = function(self)
		local h = type(self.height) == "function" and self.height(self) or self.height
		return math.floor((vim.o.lines - h) / 2)
	end,
	col = function(self)
		local w = type(self.width) == "function" and self.width(self) or self.width
		return math.floor((vim.o.columns - w) / 2)
	end,
	show_term_tag = true,
	border = 'rounded',
	term_hl = 'Normal',
	border_hl = 'FloatBorder',
	winblend = 10,
	fullscreen = false,
}

local opts = {}

local term_buf_active_count = 0
local term_buf_active_counts = {}
local term_bufs = {}
local term_wins = {}
local term_last_wins = {}
local term_tmodes = {}

local tag_bufs = {}
local tag_wins = {}

for i = 0, 9 do
	term_buf_active_counts[i] = 0
end

function M.setup(user_opts)
	opts = vim.tbl_deep_extend("force", {}, default_opts, user_opts or {})
end

local function get_term_tag(tag)
	if tag < 0 or tag > 9 then
		vim.notify('Invalid terminal tag: ' .. tag, vim.log.levels.ERROR)
		return 0
	end
	if tag == 0 then
		local max_tag, max_count = 1, 0
		for i = 1, 9 do
			if term_bufs[i] and vim.api.nvim_buf_is_valid(term_bufs[i]) and term_buf_active_counts[i] > max_count then
				max_tag, max_count = i, term_buf_active_counts[i]
			end
		end
		return max_tag
	else
		return tag
	end
end

local function create_tag_overlay(tag, win_opts)
	if not opts.show_term_tag then return nil, nil end

	local label = '[' .. tag .. ']'
	if not tag_bufs[tag] or not vim.api.nvim_buf_is_valid(tag_bufs[tag]) then
		tag_bufs[tag] = vim.api.nvim_create_buf(false, true)
	end

	vim.api.nvim_buf_set_lines(tag_bufs[tag], 0, -1, false, { label })
	vim.api.nvim_buf_set_option(tag_bufs[tag], 'modifiable', false)
	vim.api.nvim_buf_set_option(tag_bufs[tag], 'bufhidden', 'wipe')

	local width = #label
	local height = 1
	local row = (win_opts.row or 0)
	local col = (win_opts.col or 0) + (win_opts.width or 0) - width - 1
	if col < 0 then col = 0 end

	local win_opts_overlay = {
		relative = 'editor',
		row = row,
		col = col,
		width = width,
		height = height,
		style = 'minimal',
		focusable = false,
		noautocmd = true,
		border = nil,
		zindex = 300,
	}

	if tag_wins[tag] and vim.api.nvim_win_is_valid(tag_wins[tag]) then
		vim.api.nvim_win_set_buf(tag_wins[tag], tag_bufs[tag])
		vim.api.nvim_win_set_config(tag_wins[tag], win_opts_overlay)
		return tag_bufs[tag], tag_wins[tag]
	end

	local win = vim.api.nvim_open_win(tag_bufs[tag], false, win_opts_overlay)
	vim.api.nvim_win_set_option(win, 'winblend', opts.winblend)
	vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:' .. opts.term_hl)
	tag_wins[tag] = win
	return tag_bufs[tag], win
end

function M.toggle_float_term(tag, no_close, tmode, cmd)
	tag = get_term_tag(tag or 0)
	if tag == 0 then return end

	-- Dynamically calculate dimensions based on current window size
	local height = type(opts.height) == "function" and opts.height(opts) or opts.height
	local width = type(opts.width) == "function" and opts.width(opts) or opts.width
	local row = type(opts.row) == "function" and opts.row(opts) or opts.row
	local col = type(opts.col) == "function" and opts.col(opts) or opts.col

	if opts.fullscreen then
		height = vim.o.lines - 2
		width = vim.o.columns - 2
		row = 1
		col = 1
	end

	local win_opts = {
		relative = 'editor',
		row = row,
		col = col,
		width = width,
		height = height,
		style = 'minimal',
		border = opts.border,
	}

	if not term_wins[tag] or not vim.api.nvim_win_is_valid(term_wins[tag]) then
		term_last_wins[tag] = vim.api.nvim_get_current_win()

		local need_termopen = false
		if not term_bufs[tag] or not vim.api.nvim_buf_is_valid(term_bufs[tag]) then
			term_bufs[tag] = vim.api.nvim_create_buf(false, false)
			need_termopen = true
		end

		term_wins[tag] = vim.api.nvim_open_win(term_bufs[tag], true, win_opts)
		vim.api.nvim_win_set_option(term_wins[tag], 'winblend', opts.winblend)
		vim.api.nvim_win_set_option(term_wins[tag], 'winhighlight', 'NormalFloat:' .. opts.term_hl)
		vim.api.nvim_win_set_var(term_wins[tag], '_multiterm_term_tag', tag)

		-- Create or update tag overlay
		local _, tag_win = create_tag_overlay(tag, win_opts)

		vim.api.nvim_create_autocmd('WinLeave', {
			buffer = term_bufs[tag],
			once = true,
			callback = function()
				if tag_win and vim.api.nvim_win_is_valid(tag_win) then
					pcall(vim.api.nvim_win_close, tag_win, true)
					tag_wins[tag], tag_bufs[tag] = nil, nil
				end
				if vim.api.nvim_win_is_valid(term_wins[tag]) then
					vim.api.nvim_win_close(term_wins[tag], true)
				end
				term_tmodes[tag] = 0
			end,
		})

		if need_termopen then
			vim.fn.termopen((cmd ~= '' and cmd) or vim.o.shell, {
				on_exit = no_close and function() end or function()
					if term_bufs[tag] and vim.api.nvim_buf_is_valid(term_bufs[tag]) then
						vim.api.nvim_buf_delete(term_bufs[tag], { force = true })
						term_bufs[tag] = nil
					end
				end,
			})
			vim.cmd('startinsert')
		elseif term_tmodes[tag] == 1 and vim.api.nvim_get_mode().mode ~= 't' then
			vim.cmd('startinsert')
		end

		term_buf_active_count = term_buf_active_count + 1
		term_buf_active_counts[tag] = term_buf_active_count
	else
		vim.api.nvim_win_close(term_wins[tag], true)
		if tag_wins[tag] and vim.api.nvim_win_is_valid(tag_wins[tag]) then
			pcall(vim.api.nvim_win_close, tag_wins[tag], true)
			tag_wins[tag], tag_bufs[tag] = nil, nil
		end
		if term_last_wins[tag] and vim.api.nvim_win_is_valid(term_last_wins[tag]) then
			vim.api.nvim_set_current_win(term_last_wins[tag])
		end
		term_tmodes[tag] = tmode
	end
end

function M.status()
	local term_tag = 0
	local max_count = 0
	local status = { active = {}, inactive = {} }

	for i = 1, 9 do
		if term_bufs[i] and vim.api.nvim_buf_is_valid(term_bufs[i]) then
			table.insert(status.active, i)
			if term_buf_active_counts[i] > max_count then
				term_tag = i
				max_count = term_buf_active_counts[i]
			end
		else
			table.insert(status.inactive, i)
		end
	end

	status.default = term_tag == 0 and 1 or term_tag
	return status
end

return M
