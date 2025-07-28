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

-- Netrw settings
vim.g.NetrwIsOpen = false
vim.g.netrw_banner = 0
vim.g.netrw_winsize = -30
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_fastbrowse = 0


-- O---------------------------------------------------------------------------O
-- |  Plugins                                                                  |
-- O---------------------------------------------------------------------------O

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
		event = "VeryLazy",
		config = function()
			require("fzf-lua").setup({
				winopts = {
					-- fullscreen = true,
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
			map("n", "<space>fk", "<Cmd>FzfLua keymaps<CR>")
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
		event = "VeryLazy",
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
		event = "VeryLazy",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = '1.*',
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
		event = "VeryLazy",
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
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<space>;",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
			{
				"<space>:",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
		},
		opts = {
			floating_window_scaling_factor = 0.92,
			yazi_floating_window_border = "none",
		},
	},

	{
		"catgoose/nvim-colorizer.lua",
		event = "VeryLazy",
		config = function()
			require("colorizer").setup({
				filetypes = {}, -- Don't enable it for any filetype by default
			})
			vim.keymap.set("n", "<space>tC", function()
				vim.cmd("ColorizerToggle")
			end, { desc = "Toggle Colorizer" })
		end,
	},

	{
		"imranzero/multiterm.nvim",
		event = "VeryLazy",
		config = function()
			require("multiterm").setup({
				vim.keymap.set({ "n", "v", "i", "t" }, "<C-z>", "<Plug>(Multiterm)"),
				vim.keymap.set("n", "<space><C-z>", "<Plug>(MultitermList)"),
			})
		end,
	},

	{ "tpope/vim-commentary",    event = "VeryLazy" },
	{ "tpope/vim-surround",      event = "VeryLazy" },
	{ "tpope/vim-repeat",        event = "VeryLazy" },
	{ "hauleth/asyncdo.vim",     event = "VeryLazy" },
	{ "mattn/emmet-vim",         event = "VeryLazy" },
	{ "gosukiwi/vim-smartpairs", event = "VeryLazy" },
	{ "lambdalisue/suda.vim",    event = "VeryLazy" },

	"Mofiqul/vscode.nvim",
	"ellisonleao/gruvbox.nvim",
})


-- O---------------------------------------------------------------------------O
-- |  Appearance                                                               |
-- O---------------------------------------------------------------------------O

-- Set colorscheme (check safely)
pcall(vim.cmd, "colorscheme gruvbox")

-- These highlit groups are consistent across all colorschemes
local function GlobalHighlights()
	vim.schedule(function()
		vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#00F700" })
		vim.api.nvim_set_hl(0, "FoldColumn", { link = "Normal" })
	end)
end
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, { callback = GlobalHighlights })

-- Neovide GUI configuration
if vim.g.neovide then
	-- Set font
	vim.o.guifont = "Iosevka Fixed:h12"

	-- Font picker in FZF
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
					vim.o.guifont = selected[1]
				end,
			},
		})
	end
	vim.api.nvim_create_user_command("FontPickerFzf", FontPickerFzfLua, {})
	vim.keymap.set("n", "<space>fF", "<Cmd>FontPickerFzf<CR>")

	-- increase/decrease font size
	vim.api.nvim_set_keymap("n", "<F12>",
		"<Cmd>lua vim.o.guifont = vim.o.guifont:gsub('h(%d+)', function(n) " ..
		"return 'h' .. tonumber(n) + 1 end)<CR>", {}
	)
	vim.api.nvim_set_keymap("n", "<S-F12>",
		"<Cmd>lua vim.o.guifont = vim.o.guifont:gsub('h(%d+)', function(n) " ..
		"return 'h' .. tonumber(n) - 1 end)<CR>", {}
	)

	vim.opt.guicursor = { "n-v-c:block-Cursor", "i-c-ci:hor10-Cursor" }
	vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#00F700" })

	-- Fix paste
	vim.keymap.set("c", "<C-S-V>", "<C-R>+")
	vim.keymap.set({ "n", "i" }, "<S-Insert>", '<Esc>"+p')

	-- Toggle fullscreen
	vim.keymap.set("n", "<A-CR>", "<Cmd>lua vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen<CR>")
end

-- Tabline
vim.o.tabline = "%!v:lua.Tabline()"

function _G.Tabline()
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

-- Statusline
vim.o.statusline = "%!v:lua.Statusline()"

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

local function git_branch()
	local null = package.config:sub(1,1) == "\\" and "nul" or "/dev/null"
	local h = io.popen("git rev-parse --abbrev-ref HEAD 2>" .. null)
	if not h then return "" end
	local b = h:read("*l") h:close()
	return b and b ~= "" and b ~= "HEAD" and (" " .. b .. " ") or ""
end

function _G.Statusline()
	local s = " "
	local mode = cmode[vim.fn.mode()] or "UNKNOWN"
	s = s .. mode .. " "
	s = s .. "%<" -- Truncate space if too long
	s = s .. "%#StatusLineNC#" -- Set highlight group
	s = s .. " %F" -- Show full file path
	s = s .. " %r%m%h" -- readonly, modified, help
	s = s .. "%=" -- Right-align the next section
	if vim.g.asyncdo then s = s .. "[running]" end
	s = s .. git_branch()
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

-- Cursorline behaviour
local cursorline_events = {
	{ event = "WinEnter",    value = true },
	{ event = "WinLeave",    value = false },
	{ event = "InsertEnter", value = false },
	{ event = "InsertLeave", value = true }
}
for _, cmd in ipairs(cursorline_events) do
	vim.api.nvim_create_autocmd(cmd.event, {
		pattern = "*",
		callback = function()
			vim.wo.cursorline = cmd.value
		end,
	})
end

-- Set Tab indent sizes
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

-- Basic smooth scrolling
function SmoothScroll(dir, dist, duration, speed)
	local steps = math.floor(dist / speed)
	local delay = math.floor(duration / steps)

	local i = 0
	local keys = dir == 'd' and string.rep("<C-e>j", speed) or string.rep("<C-y>k", speed)
	local feed = vim.api.nvim_replace_termcodes(keys, true, false, true)

	local function step()
		if i >= steps then return end
		i = i + 1
		vim.api.nvim_feedkeys(feed, 'n', false)
		vim.cmd('redraw')
		vim.defer_fn(step, delay)
	end

	step()
end


-- O---------------------------------------------------------------------------O
-- |  Misc.                                                                    |
-- O---------------------------------------------------------------------------O

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

-- Lua 5.2+ or fallback to 5.1
local unpack_ = table.unpack or rawget(_G, "unpack")

-- Remove trailing whitespace and newlines at end of file & reset cursor position
local function StripWhitespace()
	local skip = { markdown = true, org = true } -- Skip certain filetypes
	if skip[vim.bo.filetype] then return end

	local row, col = unpack_(vim.api.nvim_win_get_cursor(0))
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

-- Turn :t to :tabe and Open :h in new tab
vim.cmd([[
	cnoreabbrev <expr> t getcmdtype() == ":" && getcmdline() ==# "t" ? "tabe" : "t"
	cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() ==# "h" ? "tab help" : "h"
]])

-- Format options
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		vim.opt.formatoptions = "jln"
	end
})

-- Hightlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end
})

-- Scratch buffer
vim.api.nvim_create_user_command("S", function()
	vim.cmd("vnew")
	vim.bo.buflisted = false
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
end, {})


-- O---------------------------------------------------------------------------O
-- |  Mappings                                                                 |
-- O---------------------------------------------------------------------------O

local map = vim.keymap.set

map({ "n", "v", "i" }, "<A-x>", "<Esc>:", { desc = "<M-x> to :" })

map({ "n", "v", "i" }, "<A-i>", "<Esc>", { desc = "<A-i> to <Esc>" })

map("n", "<2-LeftMouse>", "i", { desc = "(double-click) to enter insert mode" })
map("i", "<2-LeftMouse>", "<Esc>", { desc = "(double-click) to escape insert mode" })

map("n", "<space>G", "<Cmd>w<CR>", { desc = "Save file" })

map("n", "<bs>", "<C-6>", { desc = "Switch to previous buffer" })

map("n", "<space>q", "<Cmd>q<CR>", { desc = "Quit" })
map("t", "<C-w>q", "<Cmd>exit<CR>", { desc = "Quit" })

map("n", "<A-j>", "5j", { desc = "Move by 5 lines" })
map("n", "<A-k>", "5k", { desc = "Move by 5 lines" })
map("v", "<A-j>", "5j", { desc = "Move by 5 lines" })
map("v", "<A-k>", "5k", { desc = "Move by 5 lines" })

map("n", "Y", "y$", { desc = "Make Y behave like other capital letters (yank until the end of the line)" })
map("n", "yc", "yygccp", { remap = true, desc = "Duplicate a line and comment out the first line" })
map("x", "p", "P", { desc = "Single yank and multiple pastes over selection" })
map("n", "gp", "`[v`]", { desc = "Reselect the last paste" })

map("n", "gh", "0", { desc = "'gh' to the beginning of line" })
map("n", "gl", "$", { desc = "'gl' to the end of line" })

map("n", "'", '`', { desc = "Swap ` and ' for marks" })
map("n", '`', "'", { desc = "Swap ` and ' for marks" })

map("n", "c", '"_c', { desc = "Change into void register" })
map("n", "C", '"_C', { desc = "Change into void register" })

map("x", "<", "<gv^", { desc = "Don't lose selection when shifting backward" })
map("x", ">", ">gv^", { desc = "Don't lose selection when shifting forward" })

map("n", "n", "nzzzv", { desc = "Keep the cursor centered when searching" })
map("n", "N", "Nzzzv", { desc = "Keep the cursor centered when searching" })

map("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Moving lines in visual mode" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Moving lines in visual mode" })

map("n", "<space>ss", ":%s//gc<Left><Left><Left>", { desc = "Search & Replace ('g' global, 'c' confirm)" })
map("n", "<Space>S", ":%s/\\<<C-R>=expand('<cword>')<CR>\\>/", { desc = "Search & replace current word under cursor" })

map("n", "<space>sn", ":%s///gn<CR>", { desc = "Number of matches on last search" })
map("x", "/", "<Esc>/\\%V", { desc = "Search within the visual range" })
map("n", "<space>sv", "/\\%V", { desc = "Search the last visual selection" })

map("x", "<space>d", 'y:%s/<C-r>"//gc<CR>', { desc = "Delete all occurrences of selected text" })

map("n", "<space>cd", "<Cmd>cd %:p:h <bar> pwd<CR>", { desc = "Change directory to current file" })

map("n", "<space>tw", "<Cmd>set wrap! wrap?<CR>", { desc = "Toggle word wrapping" })
map("n", "<space>tn", "<Cmd>set number! number?<CR>", { desc = "Toggle line numbers" })

map("n", "<space>t2", "<Cmd>SetTab 2<CR>", { desc = "Switch tab-width to 2" })
map("n", "<space>t4", "<Cmd>SetTab 4<CR>", { desc = "Switch tab-width to 4" })
map("n", "<space>t8", "<Cmd>SetTab 8<CR>", { desc = "Switch tab-width to 8" })

map("n", "<F5>", Run, { silent = true }, { desc = "Run asynchronously (with AsyncDo)" })
map("n", "<F6>", Format, { silent = true }, { desc = "Format asynchronously (with AsyncDo)" })
map("n", "<F7>", Build, { silent = true }, { desc = "Build asynchronously (with AsyncDo)" })

map("n", "<space>w", "<C-w>", { desc = "Split navigation prefix" })
map("n", "<C-space>", "<C-w>w", { desc = "Go to previous split" })
map("t", "<C-space>", "<C-\\><C-n><C-w>p", { desc = "Go to previous split" })
map("t", "<C-w>N", "<C-\\><C-n>", { desc = "Terminal escape" })
map("t", "<A-i>", "<C-\\><C-n>", { desc = "Terminal escape" })

map("n", "<C-Up>", "<Cmd>res +3<CR>", { desc = "Split resizing" })
map("n", "<C-Down>", "<Cmd>res -3<CR>", { desc = "Split resizing" })
map("n", "<C-Left>", "<Cmd>vert res +3<CR>", { desc = "Split resizing" })
map("n", "<C-Right>", "<Cmd>vert res -3<CR>", { desc = "Split resizing" })

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
map("c", "<A-f>", "<S-Right>")
map("c", "<A-b>", "<S-Left>")
map("c", "<C-BS>", "<C-w>")
map("c", "<Esc>", "<C-c><Esc>")

-- Insert Mode Mappings (Readline-style)
map("i", "<C-a>", "<Home>")
map("i", "<C-e>", "<End>")
map("i", "<C-b>", "<Left>")
map("i", "<C-f>", "<Right>")
map("i", "<C-d>", "<Del>")
map("i", "<A-f>", "<C-right>")
map("i", "<A-b>", "<C-left>")
map("i", "<A-n>", "<C-o>j")
map("i", "<A-p>", "<C-o>k")
map("i", "<C-u>", "<C-g>u<C-u>")
map("i", "<C-BS>", "<C-w>")
map("i", "<S-Left>", "<Esc>v<C-g><Left>")
map("i", "<S-Right>", "<Esc>v<C-g><Right>")
map("i", "<C-Up>", function() vim.cmd("keepjumps normal! " .. vim.v.count1 .. "{") end)
map("i", "<C-Down>", function() vim.cmd("keepjumps normal! " .. vim.v.count1 .. "}") end)

-- Clipboard integration
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

map("c", "<C-n>", function()
	return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>"
end, { expr = true }, { desc = "Saner command-line history" })
map("c", "<C-p>", function()
	return vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>"
end, { expr = true }, { desc = "Saner command-line history" })

map("n", "H", function()
	local current_line = vim.fn.line(".")
	vim.cmd("normal! H")
	if current_line == vim.fn.line(".") then vim.cmd("normal! zb") end
end, { desc = "Better pgup" })
map("n", "L", function()
	local current_line = vim.fn.line(".")
	vim.cmd("normal! L")
	if current_line == vim.fn.line("$") then vim.cmd("normal! zb") end
	if current_line == vim.fn.line(".") then vim.cmd("normal! zt") end
end, { desc = "Better pgdn" })

map("n", "<space>k", function()
	local row, col = unpack_(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
	local indent = line:match("^%s*")
	local first, second = line:sub(1, col), line:sub(col + 1)

	vim.api.nvim_buf_set_lines(0, row - 1, row, false, { first })
	vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. second })
	vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
	vim.fn.histdel("/", -1)
end, { desc = "Break line at cursor (opposite of J)" })

map("n", "<space>bo", function()
	local current = vim.fn.bufnr("%")
	local to_wipe = vim.tbl_filter(function(buf)
		return buf.hidden and buf.bufnr ~= current
	end, vim.fn.getbufinfo())

	if #to_wipe > 0 then
		local bufnrs = vim.tbl_map(function(buf) return buf.bufnr end, to_wipe)
		vim.cmd("confirm bwipeout " .. table.concat(bufnrs, " "))
	end
end, { desc = "Wipe out all buffers except the current one" })

map("n", "<space>wm", function()
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
end, { desc = "Maximize/Restore current window split" })

map("n", "<space>ti", function()
	local ts = vim.o.tabstop
	if ts == 2 then
		vim.opt.listchars = { tab = "· ", leadmultispace = "· " }
	elseif ts == 4 then
		vim.opt.listchars = { tab = "· ", leadmultispace = "·   " }
	elseif ts == 8 then
		vim.opt.listchars = { tab = "· ", leadmultispace = "·       " }
	end
	vim.opt.list = not vim.o.list
end, { desc = "Toggle indent guides" })

map("n", "<C-q>", function()
	local is_qf = vim.fn.getwininfo(vim.fn.win_getid())[1].quickfix == 1
	vim.cmd(is_qf and "cclose" or "copen")
end, { desc = "Toggle quickfix window" })

map("n", "<space>tl", function()
	vim.cmd("set listchars=tab:·\\ ,space:·,precedes:<,extends:>,eol:¬")
	vim.cmd("set list!")
end, { desc = "Toggle hidden characters" })

map("n", "<space>tc", function()
	vim.o.background = (vim.o.background == "light") and "dark" or "light"
end, { desc = "Toggle light/dark theme" })

map("n", "<space>cc", function()
	local col = vim.fn.virtcol(".")
	local cc = {}
	for val in vim.wo.colorcolumn:gmatch("%d+") do
		table.insert(cc, tonumber(val))
	end

	if vim.tbl_contains(cc, col) then
		vim.cmd("setlocal colorcolumn-=" .. col)
	else
		table.insert(cc, col)
		table.sort(cc)
		vim.wo.colorcolumn = table.concat(cc, ",")
	end

	vim.cmd("setlocal varsofttabstop&")
	if #cc > 1 or (#cc == 1 and cc[1] < 60) then
		local shift = 1
		for _, v in ipairs(cc) do
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
end, { desc = "Toggle colorcolumn at cursor & set varsofttabstop accordingly" })

map("n", "<space>cC", function()
	local buf = vim.api.nvim_get_current_buf()
	local cc = vim.wo.colorcolumn
	if cc == "" then
		vim.wo.colorcolumn = vim.b[buf].cc or "80"
	else
		vim.b[buf].cc = cc
		vim.wo.colorcolumn = ""
	end
end, { desc = "Toggle all colorcolumns on/off" })

map("n", "<C-;>", function()
	if vim.g.NetrwIsOpen then
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].filetype == "netrw" then
				vim.cmd("silent! bwipeout " .. buf)
			end
		end
		vim.g.NetrwIsOpen = false
	else
		vim.g.NetrwIsOpen = true
		vim.cmd("silent! Vexplore")
		vim.defer_fn(function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype == "netrw" then
					local opts = { buffer = buf, silent = true, noremap = false }
					vim.keymap.set("n", ".", "gh", opts)
					vim.opt_local.statusline = " %f"
				end
			end
		end, 50) -- Delay to ensure Netrw is loaded
	end
end, { noremap = true, silent = true, desc = "Toggle netrw" })

if not vim.g.neovide then
	map('n', '<C-d>', function()
		local dist = math.floor(vim.api.nvim_win_get_height(0) / 2)
		SmoothScroll('d', dist, 50, 4)
	end, { noremap = true, silent = true, desc = "Smooth scroll" })

	map('n', '<C-u>', function()
		local dist = math.floor(vim.api.nvim_win_get_height(0) / 2)
		SmoothScroll('u', dist, 50, 4)
	end, { noremap = true, silent = true, desc = "Smooth scroll" })
end
