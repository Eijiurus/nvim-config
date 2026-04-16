# Neovim Configuration 🛠️

My personal Neovim configuration, built with Lua and managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## 📂 Directory Structure

```text
~/.config/nvim/
├── init.lua              # Entry point (bootstraps lazy.nvim)
├── lazy-lock.json        # Lockfile for plugin versions (do not edit manually)
├── config/
│   ├── default.lua       # Core vim.opt settings (UI, tabs, formatting)
│   ├── keymaps.lua       # Custom keybindings
│   └── autocmds.lua      # Auto commands (e.g., highlight on yank)
└── lua/
    └── plugins/          # Plugin specifications
        ├── core.lua      # Telescope, Treesitter, WhichKey
        ├── lsp.lua       # Mason, LSPConfig, CMP (Autocomplete)
        └── ui.lua        # Colorscheme, Lualine, NvimTree


## 🧠 Core Functionality (`lua/plugins/core.lua`)

These plugins provide the "engine" for navigation and syntax highlighting.

### 1. Telescope (`nvim-telescope/telescope.nvim`)
* **What is it?**: A "Fuzzy Finder." It lets you find any file or text in your project instantly by typing partial names.
* **How to use**:
    * **`<Space> + ff`**: Find File. Opens a list of all files. Type `conf` to instantly find `config.lua`.
    * **`<Space> + fg`**: Live Grep. Searches for *text* inside files. Type `function main` to see every place that function is defined.
    * **`<Space> + fb`**: Find Buffer. Switches between currently open tabs.

### 2. Treesitter (`nvim-treesitter/nvim-treesitter`)
* **What is it?**: A high-performance parser that understands the *structure* of code, not just the text.
* **Why use it?**:
    * Provides much better syntax highlighting (variables in one color, functions in another).
    * Enables advanced features like "smart indentation" and "code folding."
* **Maintenance**:
    * If syntax highlighting looks broken, run `:TSUpdate` to refresh the parsers.



## lsp.lua

## 🎨 UI & Utilities Configuration

This section configures the visual appearance and "Quality of Life" improvements for Neovim.

### 1. Colorscheme (`catppuccin/nvim`)
* **What is it?**: A soothing, modern pastel color theme that defines how your code and interface look.
* **When to use**: It runs automatically on startup.
* **Configuration**:
    * `priority = 1000`: Ensures the theme loads **before** anything else (so you don't see a flash of unstyled UI).
    * `vim.cmd.colorscheme "catppuccin"`: Sets the active theme.

### 2. Status Line (`nvim-lualine/lualine.nvim`)
* **What is it?**: Replaces the default white bar at the bottom of the screen with a colorful, informative status line.
* **What it shows**: Current Git branch, filename, file type (lua/py/js), and current mode (NORMAL/INSERT).
* **Configuration**:
    * `theme = 'catppuccin'`: It is linked to the main colorscheme so they match perfectly.

### 3. Auto Pairs (`windwp/nvim-autopairs`)
* **What is it?**: A typing assistant that automatically closes pairs.
* **How to use**:
    * Type `(` → It inserts `()` and puts your cursor in the middle.
    * Type `"` → It inserts `""` and puts your cursor in the middle.
    * Works for: `()`, `[]`, `{}`, `""`, `''`.
    
### 4. Easy Comments (`numToStr/Comment.nvim`)
* **What is it?**: A plugin to quickly toggle comments on code without manually typing `--` or `#` or `//`.
* **How to use**:
    * **`gcc`**: Toggles comment on the **current line**.
    * **`gc` + `j`**: Comments the current line and the one below it.
    * **Visual Mode**: Select a block of text and press **`gc`** to comment the whole block.

### 5. File Explorer (`nvim-tree/nvim-tree.lua`)
* **What is it?**: A sidebar file manager (like the one in VS Code).
* **How to use**:
    * **Toggle**: Press `<Space> + e` (mapped to `<leader>e`) to open or close the tree.
    * **Open File**: Navigate to a file and press `Enter`. The cursor will automatically move to the file.
    * **Switch Windows**: If you are stuck in the tree but want to edit code without opening a new file:
        * Press `Ctrl + w` then `l` (move right to code).
        * Press `Ctrl + w` then `h` (move left to tree).
    * **File Ops**: Inside the tree, press `a` (add), `r` (rename), or `d` (delete).

### 6. Bufferline (`akinsho/bufferline.nvim`)
* **What is it?**: A "Tab Bar" at the top of the window that lists open files.
* **Features**:
    * Shows LSP Errors directly in the tab name.
    * Hides unnecessary "close" buttons for a cleaner UI.
* **Controls**:
    * `<Tab>` / `<S-Tab>`: Cycle through open files.
    * `<Leader>bp`: "Pick" mode (jump to any tab by typing its letter).


## 🗂️ Buffers, Windows & Tabs

Understanding the Neovim hierarchy:

* **Buffer**: The file text held in RAM. (The thing you edit).
* **Window**: The viewport displaying a buffer. (The thing you look at).
* **Tab**: A workspace containing a specific layout of windows.

### ⌨️ Key Navigation

| Context | Keybinding | Action |
| :--- | :--- | :--- |
| **Windows** | `<C-h>` / `<C-l>` | Move Left / Right |
| | `<C-j>` / `<C-k>` | Move Down / Up |
| | `<Leader>sv` | Split Vertically (Custom) |
| | `<Leader>sh` | Split Horizontally (Custom) |
| **Buffers** | `<Tab>` | Next Buffer |
| | `<S-Tab>` | Previous Buffer |
| | `<Leader>x` | Close Buffer |


