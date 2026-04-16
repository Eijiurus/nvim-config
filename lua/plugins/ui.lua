return {
	-- 1. Colorscheme
	{
		"theniceboy/nvim-deus",
		lazy = false,
		priority = 1000,
		config = function()
		--	vim.cmd([[colorscheme deus]])
		end,
	},

	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai-pro").setup({
				filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
			})
			vim.cmd("colorscheme monokai-pro")
		end,
	},

	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- Notify
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			vim.notify = function(msg, ...)
				if string.match(msg, "error drawing label for") then
					return
				end
				require("notify")(msg, ...)
			end
			notify.setup({
				on_open = function(win)
					vim.api.nvim_win_set_config(win, { border = "none" })
				end,
				background_colour = "#202020",
				fps = 60,
				level = 2,
				minimum_width = 50,
				render = "compact",
				stages = "fade_in_slide_out",
				timeout = 3000,
				top_down = true
			})
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", ",;", function()
				require('telescope').extensions.notify.notify({
					layout_strategy = 'vertical',
					layout_config = {
						width = 0.9,
						height = 0.9,
						-- preview_height = 0.1,
					},
					wrap_results = true,
					previewer = false,
				})
			end, opts);
			vim.keymap.set("n", "<LEADER>c;", notify.dismiss, opts);
		end
	},

}
