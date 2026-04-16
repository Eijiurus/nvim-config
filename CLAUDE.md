# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using Lua and lazy.nvim as the plugin manager. The configuration targets Neovim 0.11+ (uses `vim.lsp.enable()` API).

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point, loads config modules
├── lua/config/
│   ├── defaults.lua            # Core vim.opt settings
│   ├── keymaps.lua             # Custom keybindings
│   └── plugins.lua             # lazy.nvim bootstrap and setup
└── lua/plugins/                # Plugin specs (auto-imported by lazy.nvim)
    ├── core.lua                # Telescope, which-key
    ├── lsp.lua                 # Mason, nvim-lspconfig (clangd, lua_ls, pylsp, ruff, texlab, tinymist)
    ├── ui.lua                  # Colorscheme (deus), nvim-notify
    ├── editor.lua              # vim-illuminate, autopairs, ufo, substitute, move, colorizer
    ├── mini.lua                # mini.ai, mini.icons, mini.surround
    └── git.lua                 # gitsigns, lazygit
```

## Key Design Decisions

- **Leader key**: Space (`<leader>`)
- **Local leader**: Backslash (`\`)
- **Tabs**: Hard tabs with width 4 (`expandtab = false`)
- **Colorscheme**: deus (theniceboy/nvim-deus)
- **LSP**: Uses native Neovim 0.11+ `vim.lsp.enable()` with Mason for installation
- **Plugin loading**: lazy.nvim with automatic import from `lua/plugins/` directory

## Important Keymaps

- `S` - Save file (`:w`)
- `Q` - Save and quit (`:wq`)
- `H/J/K/L` - Enhanced movement: `H`=`0`, `J`=`5j`, `K`=`5k`, `L`=`$`
- `;` - Command mode (replaces `:` in normal/visual)
- `jk` - Exit insert mode (via mapping table, currently commented out in loop)
- `<leader>ff/fg/fb` - Telescope find files/grep/buffers
- `gd/gD` - LSP go to definition (normal/split window)
- `<leader>lf` - LSP format
- `<leader>th` - Toggle inlay hints
- `[f/]f` - Jump to function start/end
- `<C-g>` - Open lazygit
- `sa/sd/sr` - mini.surround add/delete/replace

## When Modifying

- Plugin specs go in `lua/plugins/*.lua` - each file returns a table of plugin specs
- Keymaps can go in `lua/config/keymaps.lua` or in plugin config functions
- LSP servers are enabled via `vim.lsp.enable("server_name")` in `lsp.lua`
- To add a new LSP, install via Mason (`:MasonInstall`) then add `vim.lsp.enable()` call
