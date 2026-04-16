-- ============================================================================
-- Typst 配置文件
-- 基于 https://www.dogeystamp.com/typst-notes2/
-- 包含：自动编译、PDF 预览、Tinymist LSP、代码片段
-- ============================================================================

return {
	-- ========================================================================
	-- 插件 1: typst.vim
	-- GitHub: kaarmu/typst.vim
	-- 功能：Typst 语法高亮和基础支持
	-- ========================================================================
	{
		"kaarmu/typst.vim",
		ft = "typst",
		-- 如果你更喜欢用 treesitter 高亮，可以禁用此插件的语法高亮
		-- init = function()
		--     vim.g.typst_syntax_highlight = 0
		-- end,
	},

	-- ========================================================================
	-- 插件 2: LuaSnip（可选，用于代码片段）
	-- GitHub: L3MON4D3/LuaSnip
	-- 功能：提供代码片段支持，加速 Typst 输入
	-- ========================================================================
	-- 注意：如果你已经在其他地方配置了 LuaSnip，可以删除这个部分
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		event = "InsertEnter",
		config = function()
			local ls = require("luasnip")

			-- ================================================================
			-- LuaSnip 基础配置
			-- ================================================================
			ls.setup({
				-- 允许跳转回已离开的片段
				history = true,
				-- 动态更新片段文本
				updateevents = "TextChanged,TextChangedI",
				-- 启用自动触发片段
				enable_autosnippets = true,
			})

			-- ================================================================
			-- 快捷键配置
			-- ================================================================
			-- Tab: 展开片段或跳转到下一个占位符
			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				else
					-- 如果不在片段中，插入普通 Tab
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
						"n",
						false
					)
				end
			end, { silent = true, desc = "LuaSnip: Expand or jump" })

			-- Shift+Tab: 跳转到上一个占位符
			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true, desc = "LuaSnip: Jump back" })

			-- ================================================================
			-- 加载 Typst 代码片段
			-- ================================================================
			-- 片段文件位置：~/.config/nvim/snippets/typst.lua
			-- 如果文件存在，会自动加载
			require("luasnip.loaders.from_lua").load({
				paths = vim.fn.stdpath("config") .. "/snippets",
			})
		end,
	},

	-- ========================================================================
	-- 插件 3: typst-preview.nvim
	-- GitHub: chomosuke/typst-preview.nvim
	-- 功能：在浏览器中实时预览 Typst 文档，低延迟，支持光标跟随
	-- 依赖：tinymist（LSP）+ websocat（WebSocket），首次 setup 时自动下载
	-- ========================================================================
	{
		'chomosuke/typst-preview.nvim',
		ft = 'typst',
		build = function()
			require('typst-preview').update()
		end,
		opts = {
			dependencies_bin = {
				['tinymist'] = 'tinymist',
			},
		},
		keys = {
			{ '<leader>tp', '<cmd>TypstPreview<cr>', desc = 'Typst preview' },
			{ '<leader>ts', '<cmd>TypstPreviewStop<cr>', desc = 'Typst preview stop' },
		},
	}
}
