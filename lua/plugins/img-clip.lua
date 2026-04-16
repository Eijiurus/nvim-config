-- ============================================================================
-- img-clip.nvim — Clipboard Image Paste for Markdown
-- ============================================================================
-- Place this file at: ~/.config/nvim/lua/plugins/img-clip.lua
-- Requires: xclip (X11) or wl-clipboard (Wayland)
--   sudo apt install xclip        # X11 / KDE Plasma
--   sudo apt install wl-clipboard  # Wayland
--
-- Images are saved to the Astro blog _images directory:
--   ~/Desktop/WorkSpace/blog/src/content/posts/_images/
--
-- Quick Reference:
--   <leader>p  — Paste image from clipboard
-- ============================================================================

return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",

	opts = {
		-- =============================================================
		-- Default Settings (optimized for Astro blog workflow)
		-- =============================================================
		default = {
			-- Absolute path to blog image directory
			dir_path = "./_images",

			-- File naming: timestamp-based to avoid collisions
			file_name = "%Y-%m-%d-%H-%M-%S",

			-- Use absolute dir_path, not relative to current file
			relative_to_current_file = false,

			-- Markdown template with relative link for Astro compatibility
			template = "![$CURSOR](./_images/$FILE_NAME)",

			-- =============================================================
			-- Drag and Drop
			-- =============================================================
			drag_and_drop = {
				enabled = true,
				insert_mode = true,
			},
		},
	},

	keys = {
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
}
