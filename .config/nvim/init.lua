-- O---------------------------------------------------------------------------O
-- |  Settings                                                                 |
-- O---------------------------------------------------------------------------O

-- Basics
vim.opt.confirm = true
vim.opt.secure = true
vim.opt.exrc = true
vim.opt.swapfile = false
vim.opt.fileformats = { "unix", "dos" }
vim.opt.nrformats:remove("octal")

-- Search & messages
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.belloff = "all"
vim.opt.shortmess:remove("S")

-- Performance
vim.opt.lazyredraw = true
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200

-- UI
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.foldcolumn = "1"
vim.opt.fillchars:append({ vert = "│" })

-- Navigation
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 12
vim.opt.sidescroll = 1
vim.opt.smoothscroll = true

-- Completion
vim.opt.wildmode = { "full" }
vim.opt.wildoptions = { "fuzzy", "pum", "tagfile" }

-- Indentation
vim.opt.expandtab = false
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.showbreak = "»"

-- Misc
vim.opt.history = 1024
vim.opt.cedit = "<C-y>"
vim.opt.completeopt = { "menu", "menuone", "preview" }
vim.opt.commentstring = "# %s"
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.virtualedit = "block"
vim.opt.listchars = {
	tab = "· ",
	space = "·",
	precedes = "<",
	extends = ">",
	eol = "¬",
}
vim.opt.wildignore = {
	"*.o", "*.so", "*.pyc", "*.dll",
	"*.png", "*.jpg", "*.webp", "*.gif", "*.pdf"
}

-- Show inline diagnostics
vim.diagnostic.config({
	virtual_text = true, signs = true, underline = true,
})


-- O---------------------------------------------------------------------------O
-- |  Plugins                                                                  |
-- O---------------------------------------------------------------------------O

-- Disable unwanted built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1

-- bootstrap lazy.nvim if it's not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("fzf-lua").setup({
				winopts = {
					fullscreen = true,
					preview = {
						flip_columns = 150,
					},
				},
			})

			local map = vim.keymap.set
			map("n", "<space>rg", "<Cmd>FzfLua live_grep_native<CR>")
			map("n", "<space>ff", "<Cmd>FzfLua files<CR>")
			map("n", "<space>fh", "<Cmd>FzfLua oldfiles<CR>")
			map("n", "<space>f:", "<Cmd>FzfLua command_history<CR>")
			map("n", "<space>f/", "<Cmd>FzfLua search_history<CR>")
			map("n", "<space>fb", "<Cmd>FzfLua buffers<CR>")
			map("n", "<space>fc", "<Cmd>FzfLua colorschemes<CR>")
			map("n", "<space>fC", "<Cmd>FzfLua commands<CR>")
			map("n", "<space>fl", "<Cmd>FzfLua lines<CR>")
			map("n", "<space>fm", "<Cmd>FzfLua marks<CR>")
			map("n", "<space>fr", "<Cmd>FzfLua registers<CR>")
			map("n", "<space>ft", "<Cmd>FzfLua filetypes<CR>")

			-- Useful duplicates
			map("n", "<space>.", "<Cmd>FzfLua files<CR>")
			map("n", "<space>,", "<Cmd>FzfLua buffers<CR>")
		end
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"ts_ls",
					"html",
					"tailwindcss",
					"phpactor",
				}
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
			vim.keymap.set("n", "d]", vim.diagnostic.goto_next, {})
		end
	},

	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",

		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			},
			signature = { enabled = true },
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = {
					"javascript",
					"typescript",
					"tsx",
					"html",
					"css",
					"json",
					"php",
					"blade",
					"go"
				},
				highlight = { enable = true },
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "blade",
				callback = function()
					vim.bo.commentstring = "{{-- %s --}}"
				end,
			})
		end
	},

	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				view     = { width = 30, side = "right", },
				renderer = { group_empty = true, },
				filters  = { dotfiles = false, },
			})
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "NvimTree_*",
				callback = function()
					vim.opt_local.statusline = " NvimTree "
				end,
			})
			vim.keymap.set("n", "<space>;", "<Cmd>NvimTreeToggle .<CR>")
		end,
	},

	{
		"chengzeyi/multiterm.vim",
		config = function()
			vim.keymap.set("n", "<C-z>", "<Plug>(Multiterm)")
			vim.keymap.set("t", "<C-z>", "<Plug>(Multiterm)")
			vim.keymap.set("i", "<C-z>", "<Plug>(Multiterm)")
		end
	},

	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({
				filetypes = {}, -- Don't enable it for any filetype by default
			})
			vim.keymap.set("n", "<space>tC", function()
				vim.cmd("ColorizerToggle")
			end, { desc = "Toggle Colorizer" })
		end,
	},

	"Mofiqul/vscode.nvim",
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "gruvbox", -- only runs when loading gruvbox
				callback = function() vim.api.nvim_set_hl(0, "FoldColumn", { link = "Normal" }) end
			})
		end
	},

	"tpope/vim-commentary",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"hauleth/asyncdo.vim",
	"mattn/emmet-vim",
	"gosukiwi/vim-smartpairs",
	"lambdalisue/suda.vim",
})


-- O---------------------------------------------------------------------------O
-- |  Misc.                                                                    |
-- O---------------------------------------------------------------------------O

-- Set colorscheme (check safely)
pcall(vim.cmd, "colorscheme vscode")

-- Neovide GUI configuration
if vim.g.neovide then
	-- Set font
	vim.o.guifont = "Iosevka Fixed:h12"

	-- GUI font picker in FZF
	local fonts = {
		"Consolas:h12",
		"Go Mono:h12",
		"Terminus (TTF):h12",
		"JetBrains Mono NL:h12",
		"Source Code Pro:h12",
		"Iosevka Fixed:h12"
	}
	local function FontPickerFzfLua()
		require("fzf-lua").fzf_exec(fonts, {
			prompt = "Font > ",
			actions = {
				["default"] = function(selected)
					local font = selected[1]
					vim.o.guifont = font
					print("Switched to font: " .. font)
				end,
			},
		})
	end
	vim.api.nvim_create_user_command("FontPickerFzf", FontPickerFzfLua, {})

	-- increase/decrease font size
	vim.api.nvim_set_keymap("n", "<F12>",
		"<Cmd>lua vim.o.guifont = vim.o.guifont:gsub('h(%d+)', function(n) " ..
		"return 'h' .. tonumber(n) + 1 end)<CR>", {}
	)
	vim.api.nvim_set_keymap("n", "<S-F12>",
		"<Cmd>lua vim.o.guifont = vim.o.guifont:gsub('h(%d+)', function(n) " ..
		"return 'h' .. tonumber(n) - 1 end)<CR>", {}
	)

	vim.opt.guicursor = {
		"n-v-c:block-Cursor", -- normal/visual/command use 'Cursor' highlight
		"i-c-ci:hor10-iCursor" -- insert/cmdline-insert use 'iCursor' highlight
	}

	vim.cmd([[
		highlight Cursor  guifg=#000000 guibg=#00F700 gui=NONE cterm=NONE
		highlight iCursor guifg=#000000 guibg=#00F700 gui=NONE cterm=NONE
	]])

	-- Fix paste
	vim.keymap.set("c", "<C-S-V>", "<C-R>+")
	vim.keymap.set({ "n", "i" }, "<S-Insert>", '<Esc>"+p')

	-- Toggle fullscreen
	vim.keymap.set("n", "<A-CR>", "<Cmd>lua vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen<CR>")
end

-- Run/execute current buffer
local function Run()
	vim.cmd("update")
	local ft = vim.bo.filetype

	if ft == "javascript" then
		vim.cmd("AsyncDo node %")
	elseif ft == "python" then
		vim.cmd("AsyncDo python %")
	elseif ft == "lua" then
		vim.cmd("AsyncDo luajit %")
	elseif ft == "lisp" then
		vim.cmd("AsyncDo sbcl --script %")
	elseif ft == "go" then
		vim.cmd("AsyncDo go run %")
	elseif ft == "php" then
		vim.cmd("AsyncDo php %")
	else
		print("This filetype (" .. ft .. ") cannot be run.")
	end
end

-- Format current buffer
local function Format()
	vim.cmd("update")
	vim.api.nvim_create_augroup("FormatReload", { clear = true }) -- Reload after formatting
	vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		group = "FormatReload",
		command = "silent! edit!"
	})
	local ft = vim.bo.filetype

	if ft == "lua" or ft == "go" or ft == "javascript" or ft == "typescript" then
		if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
			vim.lsp.buf.format({ async = true })
		else
			print("No LSP client attached for " .. ft)
		end
	elseif ft == "c" or ft == "cpp" then
		local args = table.concat({
			"--style=kr", "--indent=tab", "--convert-tabs", "--break-blocks", "--pad-oper",
			"--pad-header", "--unpad-paren", "--align-pointer=name", "--attach-return-type",
			"--indent-preproc-block", "--max-code-length=80", "--break-after-logical", "--suffix=none"
		}, " ")
		vim.cmd("AsyncDo astyle " .. args .. " %")
	else
		print("This filetype (" .. ft .. ") cannot be formatted.")
	end
end

-- Build/Make if makefile present in CWD
local function Build()
	local has_makefile = vim.fn.filereadable("makefile") == 1 or vim.fn.filereadable("Makefile") == 1
	if has_makefile then
		vim.cmd("update")
		vim.bo.makeprg = "make"
		vim.cmd("AsyncDo make")
	else
		print("No makefile found in the current directory.")
	end
end

-- Tabline & Statusline

local TL = {} -- Store in module-like table
vim.o.tabline = "%!v:lua.require'tabline'.tabline()"

function TL.tabline()
	local s = ""
	for i = 1, vim.fn.tabpagenr('$') do
		local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
		local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
		name = name ~= "" and name or "[No Name]"
		local hl = (i == vim.fn.tabpagenr()) and "%#StatusLine#" or "%#StatusLineNC#"
		s = s .. hl .. (" %d: %s "):format(i, name)
	end

	s = s .. "%#StatusLineNC#%=" -- Highlight & right-align

	local size = math.max(vim.fn.getfsize(vim.api.nvim_buf_get_name(0)), 0)
	s = s .. "%#StatusLine#" .. (" [%s] [%s] [%.1fKB] "):format(
		vim.bo.fileformat or "?", vim.bo.fileencoding or "?", size / 1024
	)

	return s
end

local SL = {} -- Store in module-like table
local cmode = {
	n = "NORMAL",
	v = "VISUAL",
	V = "V·LINE",
	["\22"] = "V·BLOCK",
	s = "SELECT",
	S = "S·LINE",
	i = "INSERT",
	R = "REPLACE",
	Rv = "V·REPLACE",
	c = "COMMAND",
	r = "PROMPT",
	t = "TERMINAL"
}
vim.o.statusline = "%!v:lua.require'statusline'.statusline()"

function SL.statusline()
	local s = " "
	local mode = cmode[vim.fn.mode()] or "UNKNOWN"
	s = s .. mode .. " "
	s = s .. "%<" -- Truncate space if too long
	s = s .. "%#StatusLineNC#" -- Set highlight group
	s = s .. " %F" -- Show full file path
	s = s .. " %r%m%h" -- readonly, modified, help
	s = s .. "%=" -- Right-align the next section
	if vim.g.asyncdo then s = s .. "[running]" end
	s = s .. " ≣ %02p%%" -- File position percentage
	s = s .. " %*" -- Reset highlight
	s = s .. " %{strlen(&filetype) ? &filetype : 'none'} |" -- Show filetype or "none"
	s = s .. " %02c:%3l/%L " -- Show column:line/total lines
	return s
end

-- Redraw statusline periodically (for AsyncDo [running] indicator)
local was_active = false
vim.loop.new_timer():start(0, 1000, vim.schedule_wrap(function()
	local active = vim.g.asyncdo ~= nil
	if active or was_active then
		vim.cmd("redrawstatus")
	end
	was_active = active
end))

package.loaded["tabline"] = TL    -- Provide tabline module
package.loaded["statusline"] = SL -- Provide statusline module

-- Scratch buffer
vim.api.nvim_create_user_command("S", function()
	vim.cmd("vnew")
	vim.bo.buflisted = false
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
end, {})

-- Maximize/Restore current window split
local function ToggleMaximize()
	local t = vim.t
	local win = vim.api.nvim_get_current_win()

	if t.restore_zoom and t.restore_zoom.win == win then
		vim.cmd(t.restore_zoom.cmd)
		t.restore_zoom = nil
	else
		t.restore_zoom = {
			win = win,
			cmd = vim.fn.winrestcmd(),
		}
		vim.cmd("resize")
		vim.cmd("vertical resize")
	end
end

-- Togggle indent guides
local function ToggleIndentGuides()
	local ts = vim.o.tabstop
	if ts == 2 then
		vim.opt.listchars = { tab = "· ", leadmultispace = "· " }
	elseif ts == 4 then
		vim.opt.listchars = { tab = "· ", leadmultispace = "·   " }
	elseif ts == 8 then
		vim.opt.listchars = { tab = "· ", leadmultispace = "·       " }
	end
	vim.opt.list = not vim.o.list
end

-- Format options
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		vim.opt.formatoptions = "jln"
	end
})

-- Autocommands for cursorline behaviour
vim.api.nvim_create_augroup("CURSORLINE", { clear = true })
local cursorline_events = {
	{ event = "WinEnter",    value = true },
	{ event = "WinLeave",    value = false },
	{ event = "InsertEnter", value = false },
	{ event = "InsertLeave", value = true }
}
for _, cmd in ipairs(cursorline_events) do
	vim.api.nvim_create_autocmd(cmd.event, {
		group = "CURSORLINE",
		pattern = "*",
		callback = function()
			vim.wo.cursorline = cmd.value
		end,
	})
end

-- Toggle colorcolumn at cursor position & set vartabstop accordingly
local function ToggleColorColumn(all)
	local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
	local function parse_colorcolumn(str)
		local cc = {}
		for val in str:gmatch("([^,]+)") do
			local num = tonumber(val)
			if num then table.insert(cc, num) end
		end
		return cc
	end

	if all then
		local cc = vim.wo[win].colorcolumn
		if cc == "" then
			vim.wo[win].colorcolumn = vim.b[buf].cc or "80"
		else
			vim.b[buf].cc = cc
			vim.wo[win].colorcolumn = ""
		end
	else
		local col = vim.fn.virtcol(".")
		local cc = parse_colorcolumn(vim.wo[win].colorcolumn)
		local exists = vim.tbl_contains(cc, col)

		if exists then
			vim.cmd("set colorcolumn-=" .. col)
		else
			table.insert(cc, col)
			table.sort(cc)
			local cc_str = vim.fn.join(cc, ",")
			vim.cmd("set colorcolumn=" .. cc_str)
		end
	end

	local cc_final = parse_colorcolumn(vim.wo[win].colorcolumn)
	vim.cmd("setlocal varsofttabstop&")
	if #cc_final > 1 or (#cc_final == 1 and cc_final[1] < 60) then
		table.sort(cc_final)
		local shift = 1
		for _, v in ipairs(cc_final) do
			local delta = v - shift
			if delta > 0 then
				vim.cmd("setlocal varsofttabstop+=" .. delta)
				shift = v
			end
		end
		local sw = tonumber(vim.o.shiftwidth)
		if sw and sw > 0 then
			vim.cmd("setlocal varsofttabstop+=" .. sw)
		end
	end
end

-- Regex-based text alignment (default: '=')
local function AlignSection(line1, line2, sep)
	sep = sep ~= "" and sep or "="
	local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)

	local maxpos = 0
	for _, line in ipairs(lines) do
		local pos = line:find("%s*" .. vim.pesc(sep))
		if pos and pos > maxpos then maxpos = pos end
	end
	for i, line in ipairs(lines) do
		local lhs, rhs = line:match("^(.-)%s*(" .. vim.pesc(sep) .. ".*)")
		if lhs and rhs then
			lines[i] = lhs .. string.rep(" ", maxpos - #lhs + 1) .. rhs
		end
	end

	vim.api.nvim_buf_set_lines(0, line1 - 1, line2, false, lines)
end
vim.api.nvim_create_user_command("Align", function(opts)
	AlignSection(opts.line1, opts.line2, opts.args or "")
end, { range = true, nargs = "?" })

-- Alternate between C/C++ source/header
local function OpenAlternate(cmd)
	local name = vim.fn.expand("%:r")
	local ext = vim.fn.expand("%:e"):lower()
	local map = {
		c = { "h", "hh", "hpp", "hxx" },
		cpp = { "h", "hh", "hpp", "hxx" },
		h = { "c", "cc", "cpp", "cxx" },
		hpp = { "c", "cc", "cpp", "cxx" },
	}
	for _, alt_ext in ipairs(map[ext] or {}) do
		local alt = name .. "." .. alt_ext
		for _, file in ipairs({ alt, alt:upper() }) do
			if vim.fn.filereadable(file) == 1 then
				vim.cmd(cmd .. " " .. vim.fn.fnameescape(file))
				return
			end
		end
	end
end
vim.api.nvim_create_user_command("A", function() OpenAlternate("edit") end, {})
vim.api.nvim_create_user_command("AV", function() OpenAlternate("botright vsplit") end, {})

-- Turn :t to :tabe and Open :h in new tab
vim.cmd([[
	cnoreabbrev <expr> t getcmdtype() == ":" && getcmdline() ==# "t" ? "tabe" : "t"
	cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() ==# "h" ? "tab help" : "h"
]])

-- Universal opposite of J
local function BreakHere()
	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))    -- Get cursor position
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] -- Get the current line
	local indent = line:match("^%s*")                                -- Get indentation
	local first_part, second_part = line:sub(1, col), line:sub(col + 1) -- Split the line

	-- Set the modified lines
	vim.api.nvim_buf_set_lines(0, row - 1, row, false, { first_part })
	vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. second_part })

	vim.api.nvim_win_set_cursor(0, { row + 1, 0 }) -- Move the cursor to the new line
	vim.fn.histdel("/", -1)                     -- Clear the last search history entry
end

-- Set Tab indet sizes
local function SetTab(n)
	n = tonumber(n)
	if n then
		vim.opt.tabstop = n
		vim.opt.softtabstop = n
		vim.opt.shiftwidth = n
		vim.opt.expandtab = false
	else
		print("Invalid tab size: " .. tostring(n))
	end
end
vim.api.nvim_create_user_command("SetTab", function(opts)
	SetTab(opts.args)
end, { nargs = 1 })

-- Toggle the quickfix window
local function ToggleQuickfix()
	if vim.fn.getwininfo(vim.fn.win_getid())[1].quickfix == 1 then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end

-- Wipe out all buffers except the current one
local function WipeHiddenBuffers()
	local current_bufnr = vim.fn.bufnr("%")        -- Get the current buffer number
	local buffers = vim.tbl_filter(function(buf)
		return buf.hidden and buf.bufnr ~= current_bufnr -- Exclude the current buffer
	end, vim.fn.getbufinfo())

	if #buffers > 0 then
		local bufnrs = vim.tbl_map(function(buf)
			return buf.bufnr
		end, buffers)
		vim.cmd("confirm bwipeout " .. table.concat(bufnrs, " "))
	end
end

-- Remove trailing whitespace and newlines at end of file & reset cursor position
local function StripWhitespace()
	local skip = { markdown = true, org = true } -- Skip certain filetypes
	if skip[vim.bo.filetype] then return end

	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	vim.cmd([[%s/\s\+$//e]])
	vim.cmd([[%s/\n\+\%$//e]])
	local max_row = vim.api.nvim_buf_line_count(0)
	row = math.min(row, max_row)
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
	col = math.min(col, #line)
	vim.api.nvim_win_set_cursor(0, { row, col })
end
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("STRIP_WHITESPACE", { clear = true }),
	pattern = "*",
	callback = StripWhitespace,
})


-- O---------------------------------------------------------------------------O
-- |  Mappings                                                                 |
-- O---------------------------------------------------------------------------O

local map = vim.keymap.set

-- <M-x> to :
map({ "n", "v", "i" }, "<M-x>", "<Esc>:")

-- <M-i> to <Esc>
map({ "n", "v", "i", "t" }, "<M-i>", "<Esc>")

-- Save file
map("n", "<space>G", "<Cmd>w<CR>")

-- Quit
map("n", "<space>q", "<Cmd>q<CR>")
map("t", "<c-w>q", "<Cmd>exit<CR>")

-- Switch to previous buffer
map("n", "<bs>", "<c-6>")

-- Wipe out all buffers except the current one
map("n", "<space>bo", WipeHiddenBuffers)

-- Split navigation
map("n", "<space>w", "<c-w>")
map("t", "<c-space>", "<C-\\><C-n><c-w>p")
map("t", "<c-w>N", "<C-\\><C-n>")
map("n", "<c-space>", "<c-w>w")

-- Split resizing
map("n", "<c-Up>", "<Cmd>res +3<CR>")
map("n", "<c-Down>", "<Cmd>res -3<CR>")
map("n", "<c-Left>", "<Cmd>vert res +3<CR>")
map("n", "<c-Right>", "<Cmd>vert res -3<CR>")
map("n", "<space>wm", ToggleMaximize)

-- Map (double-click) to enter insert mode and escape in insert mode
map("n", "<2-LeftMouse>", "i")
map("i", "<2-LeftMouse>", "<Esc>")

-- Map <M-j> and <M-k> to move by 5 lines
map("n", "<M-j>", "5j")
map("n", "<M-k>", "5k")
map("v", "<M-j>", "5j")
map("v", "<M-k>", "5k")

-- Map `gh` to go to the beginning of the line and `gl` to go to the end
map("n", "gh", "0")
map("n", "gl", "$")

-- Swap ` and ' for marks
map("n", "'", '`')
map("n", '`', "'")

-- Change into void register
map("n", "c", '"_c')
map("n", "C", '"_C')

-- Make Y behave like other capital letters (yank until the end of the line)
map("n", "Y", "y$")

-- Terminal Mode
map("n", "<space><CR>", "<Cmd>vert term<CR>i")
map("n", "<space><S-cr>", "<Cmd>hor term<CR>i")
map("n", "<space><C-cr>", "<Cmd>tab term<CR>i")
map("t", "<S-Insert>", '<C-\\><C-n>"+pi')
map("t", "<C-v>", '<C-\\><C-n>"+pi')

-- Command Mode Mappings
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<C-b>", "<Left>")
map("c", "<C-f>", "<Right>")
map("c", "<C-k>", "<C-o>d$")
map("c", "<M-f>", "<S-Right>")
map("c", "<M-b>", "<S-Left>")
map("c", "<C-BS>", "<C-w>")
map("c", "<Esc>", "<C-c><Esc>")

-- Insert Mode Mappings (Readline-style)
map("i", "<C-a>", "<Home>")
map("i", "<C-e>", "<End>")
map("i", "<C-b>", "<Left>")
map("i", "<C-f>", "<Right>")
map("i", "<C-k>", "<C-o>d$")
map("i", "<C-d>", "<Del>")
map("i", "<M-f>", "<C-right>")
map("i", "<M-b>", "<C-left>")
map("i", "<M-n>", "<C-o>j")
map("i", "<M-p>", "<C-o>k")
map("i", "<C-u>", "<C-g>u<C-u>")
map("i", "<C-BS>", "<C-w>")
map("i", "<S-Left>", "<Esc>v<C-g><Left>")
map("i", "<S-Right>", "<Esc>v<C-g><Right>")
map("i", "<C-Up>", function() vim.cmd("keepjumps normal! " .. vim.v.count1 .. "{") end)
map("i", "<C-Down>", function() vim.cmd("keepjumps normal! " .. vim.v.count1 .. "}") end)

-- Better page up/down
map("n", "L", function()
	local current_line = vim.fn.line(".")
	vim.cmd("normal! L")
	if current_line == vim.fn.line("$") then vim.cmd("normal! zb") end
	if current_line == vim.fn.line(".") then vim.cmd("normal! zt") end
end)
map("n", "H", function()
	local current_line = vim.fn.line(".")
	vim.cmd("normal! H")
	if current_line == vim.fn.line(".") then vim.cmd("normal! zb") end
end)

-- Saner command-line history
map("c", "<C-n>", function()
	return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>"
end, { expr = true })
map("c", "<C-p>", function()
	return vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>"
end, { expr = true })

-- Single yank and multiple pastes over selection
map("x", "p", "P")

-- Keep the cursor centered when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Reselect the last paste
map("n", "gp", "`[v`]")

-- Don't lose selection when shifting sidewards
map("x", "<", "<gv^")
map("x", ">", ">gv^")

-- Moving lines in visual mode
map("v", "<C-j>", "<Cmd>m '>+1<CR>gv=gv")
map("v", "<C-k>", "<Cmd>m '<-2<CR>gv=gv")

-- Search & Replace ('g' global, 'c' confirm)
map("n", "<space>ss", ":%s//gc<Left><Left><Left>")

-- Search for the current word under the cursor and replace it
map("n", "<Space>S", ":%s/\\<<C-R>=expand('<cword>')<CR>\\>/")

-- Number of matches on last search
map("n", "<space>sn", ":%s///gn<CR>")

-- Search within the visual range
map("x", "/", "<Esc>/\\%V")

-- Search the last visual selection
map("n", "<space>sv", "/\\%V")

-- Delete all occurrences of selected text
map("x", "<space>d", 'y:%s/<C-r>"//gc<CR>')

-- Change directory to current file
map("n", "<space>cd", "<Cmd>cd %:p:h <bar> pwd<CR>")

-- Toggle word wrapping
map("n", "<space>tw", "<Cmd>set wrap! wrap?<CR>")

-- Toggle line numbers
map("n", "<space>tn", "<Cmd>set number! number?<CR>")

-- Toggle hidden characters
map("n", "<space>tl", function()
	vim.cmd("set listchars=tab:·\\ ,space:·,precedes:<,extends:>,eol:¬")
	vim.cmd("set list!")
end)

-- Toggle light/dark theme
map("n", "<space>tc", function()
	vim.o.background = (vim.o.background == "light") and "dark" or "light"
end)

-- Clipboard integration (Wayland or X11 specific)
if os.getenv("XDG_SESSION_TYPE") == "wayland" then
	map("x", '"+y', [[y<Cmd>call system('wl-copy', @")<CR>]])
	map("n", '"+p', [[<Cmd>let @"=substitute(system('wl-paste --no-newline'), "\r", "", "g")<CR>p]])
	map("n", '"*p', [[<Cmd>let @"=substitute(system('wl-paste --no-newline --primary'), "\r", "", "g")<CR>p]])
	map("x", "<space>y", '"+y')
	map("n", "<space>p", '"+p')
else
	map("x", "<space>y", '"+y')
	map("n", "<space>p", '"+p')
	map("n", "<space>P", '"+P')
end

-- Toggle indent guides
map("n", "<space>ti", ToggleIndentGuides)

-- Toggle quickfix window
map("n", "<C-q>", ToggleQuickfix)

-- Universal opposite of J
map("n", "<space>k", BreakHere)

-- Key mappings for quick tab width switching
map("n", "<space>t2", "<Cmd>SetTab 2<CR>")
map("n", "<space>t4", "<Cmd>SetTab 4<CR>")
map("n", "<space>t8", "<Cmd>SetTab 8<CR>")

-- Toggle colorcolumn at cursor position & set vartabstop accordingly
map("n", "<space>cc", function() ToggleColorColumn(false) end)
map("n", "<space>cC", function() ToggleColorColumn(true) end)

-- Asynchronously Run, Format & Build
map("n", "<F5>", Run, { silent = true })
map("n", "<F6>", Format, { silent = true })
map("n", "<F7>", Build, { silent = true })
