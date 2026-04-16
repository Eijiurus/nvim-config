return {
    -- 1. Telescope: The fuzzy finder (find files, grep text, etc.)
    -- Dependencies: 'plenary.nvim' is a library used by many plugins
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Find File
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})  -- Find Grep (Text)
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})    -- Find Buffer
        end
    },

    -- 2. Treesitter: Better syntax highlighting and code parsing
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        priority = 50,
        config = function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if ok then
                configs.setup({
                    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "typescript", "tsx", "markdown", "markdown_inline" },
                    auto_install = true,
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                })
            else
                vim.notify("nvim-treesitter not loaded yet, parsers will be available after restart", vim.log.levels.WARN)
            end
        end
    },
    
    -- 3. Which-Key: Helps you remember keybindings (pops up a menu)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },
}
