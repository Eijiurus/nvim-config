vim.o.termguicolors = true -- Enable 24-bit RGB colors in the terminal
vim.env.TERM_PROGRAM = "kitty"

-- Disable unused providers
vim.g.loaded_perl_provider = 0 -- Disable Perl provider for faster startup
vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider for faster startup

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus' -- Use system clipboard for all yank/paste operations
end)

-- General
vim.o.autochdir = true -- Auto change directory to current file's location
vim.o.exrc = true -- Allow loading local .nvimrc/.exrc config files
vim.o.secure = true -- ⚠️ Restrict commands in local config files for security
vim.o.cursorline = true -- Highlight the current line
vim.o.undofile = true -- Persist undo history to disk between sessions
vim.o.ttimeoutlen = 0 -- No delay for key code sequences (e.g., <Esc>)
vim.o.timeout = false -- Disable timeout for mapped key sequences
vim.o.viewoptions = 'cursor,folds,slash,unix' -- What to save in view files (cursor pos, folds, etc.)

-- Make line numbers default
vim.o.number = true -- Show absolute line numbers
vim.o.relativenumber = true -- Show relative line numbers (hybrid with number=true)

-- Indentation (tabs)
vim.o.shiftwidth = 4 -- Number of spaces for each indent level
vim.o.softtabstop = 4 -- Number of spaces a <Tab> counts for while editing
vim.o.autoindent = true -- Copy indent from current line when starting a new line
vim.o.tabstop = 4 -- Number of spaces a <Tab> character displays as
vim.o.smarttab = true -- <Tab> at line start uses shiftwidth, elsewhere uses tabstop
vim.o.expandtab = false -- Use actual tab characters, not spaces
vim.o.indentexpr = '' -- Disable automatic expression-based indentation

-- Whitespace display
vim.o.list = true -- Show invisible characters
vim.o.listchars = 'tab:|\\ ,trail:▫' -- Display tabs as "| " and trailing spaces as "▫"

-- Wrapping
vim.o.wrap = true -- Wrap long lines visually
vim.o.textwidth = 0 -- Disable automatic line breaking (no hard wraps)
vim.o.scrolloff = 4 -- Keep 4 lines visible above/below cursor when scrolling
vim.o.formatoptions = vim.o.formatoptions:gsub('tc', '') -- Disable auto-wrap text and comments

-- Folding
vim.o.foldmethod = 'indent' -- Create folds based on indentation levels
vim.o.foldlevel = 99 -- Folds with level > 99 are closed (effectively all open)
vim.o.foldenable = true -- Enable folding functionality
vim.o.foldlevelstart = 99 -- Open files with all folds expanded

-- Splits
vim.o.splitright = true -- New vertical splits open to the right
vim.o.splitbelow = true -- New horizontal splits open below
vim.o.showmode = false -- Don't show mode in cmdline (useful with statusline plugins)

-- Search
vim.o.ignorecase = true -- Case-insensitive searching
vim.o.smartcase = true -- Case-sensitive if search contains uppercase
vim.o.inccommand = 'split' -- Show live preview of :substitute in a split window

-- Completion
vim.o.completeopt = 'menuone,noinsert,noselect,preview' -- Completion menu behavior settings
vim.o.shortmess = vim.o.shortmess .. 'c' -- Don't show completion messages (e.g., "match 1 of 2")
