-- ============================================================================
-- avante.nvim — AI Code Assistant (Qwen Plus via DashScope)
-- ============================================================================
-- Place this file at: ~/.config/nvim/lua/plugins/avante.lua
--
-- Environment variable needed (add to .bashrc / .zshrc):
--   export DASHSCOPE_API_KEY="sk-xxx"   # 阿里云百炼 API Key
--
-- Quick Reference:
--   <leader>aa  — Ask AI about current code / selection
--   <leader>ae  — Edit selected code with AI
--   <leader>ar  — Refresh AI response
--   <leader>at  — Toggle Avante sidebar
--   <leader>af  — Focus Avante sidebar
--   co          — Choose ours (in conflict resolution)
--   ct          — Choose theirs
--   ca          — Choose all
--   c0          — Choose none
--   ]x          — Next conflict
--   [x          — Previous conflict
-- ============================================================================

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false,
	build = "make",

	opts = {
		-- =============================================================
		-- Provider: Qwen Plus via DashScope (OpenAI-compatible)
		-- =============================================================
		provider = "qwen",
		providers = {
			qwen = {
				__inherited_from = "openai",
				api_key_name = "DASHSCOPE_API_KEY",
				endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
				model = "qwen-plus",
				extra_request_body = {
					max_tokens = 8192,
				},
			},
		},

		-- Disable web search to avoid Tavily API dependency
		disabled_tools = { "web_search" },

		-- =============================================================
		-- Behavior
		-- =============================================================
		behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
		},

		-- =============================================================
		-- UI
		-- =============================================================
		windows = {
			position = "right",
			width = 40,
			sidebar_header = {
				rounded = true,
			},
		},

		hints = {
			enabled = true,
		},
	},

	keys = {
		{ "<leader>an", "<cmd>AvanteChatNew<CR>", desc = "Avante: New Chat" },
		{ "<leader>al", "<cmd>AvanteClear<CR>", desc = "Avante: Clear Chat" },
	},

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
}
