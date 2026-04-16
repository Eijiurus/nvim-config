-- ============================================
-- Leader Key
-- ============================================
vim.g.mapleader = " " -- Set space as the leader key

-- ============================================
-- Mode Definitions
-- ============================================
local mode_n  = { "n" }      -- Normal mode
local mode_v  = { "v" }      -- Visual mode
local mode_i  = { "i" }      -- Insert mode
local mode_nv = { "n", "v" } -- Normal + Visual mode

-- ============================================
-- All Key Mappings
-- ============================================
local nmappings = {
    -- ========== Basic Operations ==========
    { from = "S", to = ":w<CR>",  mode = mode_n, desc = "Save file" },
    { from = "Q", to = ":wq<CR>", mode = mode_n, desc = "Save and quit" },

    -- ========== Movement Enhancements ==========
    { from = "j", to = "gj", mode = mode_n, desc = "Move down (visual line)" },
    { from = "k", to = "gk", mode = mode_n, desc = "Move up (visual line)" },
    { from = "H", to = "0",  mode = mode_n, desc = "Go to line start" },
    { from = "L", to = "$",  mode = mode_n, desc = "Go to line end" },
    { from = "J", to = "5j", mode = mode_n, desc = "Move down 5 lines" },
    { from = "K", to = "5k", mode = mode_n, desc = "Move up 5 lines" },

    -- ========== Visual Mode ==========
    { from = "J", to = ":m '>+1<CR>gv=gv", mode = mode_v, desc = "Move selection down" },
    { from = "K", to = ":m '<-2<CR>gv=gv", mode = mode_v, desc = "Move selection up" },
    { from = "Y", to = '"+y',              mode = mode_v, desc = "Yank to system clipboard" },

    -- ========== Search ==========
    { from = "<leader>nh",   to = ":nohl<CR>", mode = mode_n, desc = "Clear search highlight" },
    { from = "<leader><CR>", to = ":noh<CR>",  mode = mode_n, desc = "Clear search highlight" },

    -- ========== Tab Management ==========
    { from = "tn",  to = ":tabe<CR>",      mode = mode_n, desc = "New tab" },
    { from = "ts",  to = ":tab split<CR>", mode = mode_n, desc = "Split to new tab" },
    { from = "tc",  to = ":tab close<CR>", mode = mode_n, desc = "Close tab" },
    { from = "th",  to = ":-tabnext<CR>",  mode = mode_n, desc = "Previous tab" },
    { from = "tl",  to = ":+tabnext<CR>",  mode = mode_n, desc = "Next tab" },
    { from = "tmh", to = ":-tabmove<CR>",  mode = mode_n, desc = "Move tab left" },
    { from = "tml", to = ":+tabmove<CR>",  mode = mode_n, desc = "Move tab right" },

    -- ========== Command Mode Shortcut ==========
    { from = ";", to = ":", mode = mode_nv, desc = "Enter command mode" },

    -- ========== Character Swap ==========
    { from = "`", to = "~", mode = mode_nv, desc = "Toggle case" },

    -- ========== Insert Mode ==========
    { from = "jk", to = "<ESC>", mode = mode_i, desc = "Exit insert mode" },
}

-- ============================================
-- Apply All Mappings
-- ============================================
for _, mapping in ipairs(nmappings) do
    vim.keymap.set(
        mapping.mode or mode_n, -- Default to normal mode
        mapping.from,           -- Key sequence
        mapping.to,             -- Action
        {
            noremap = true,             -- Non-recursive mapping
            silent = true,              -- Don't show command in cmdline
            desc = mapping.desc or "",  -- Description for which-key
        }
    )
end
