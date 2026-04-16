-- ============================================================================
-- MDX 配置文件
-- 为 .mdx 文件提供语法高亮、补全和 LSP 支持
-- MDX = Markdown + JSX (用于 Astro、Next.js 等框架)
-- ============================================================================

return {
	-- ========================================================================
	-- MDX 文件类型检测和配置
	-- ========================================================================
	{
		"neovim/nvim-lspconfig",
		optional = true,
		init = function()
			-- ================================================================
			-- 文件类型检测：将 .mdx 识别为 mdx 文件类型
			-- ================================================================
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})

			-- ================================================================
			-- MDX 文件专用设置
			-- ================================================================
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "mdx",
				callback = function()
					-- 基本编辑器选项
					vim.opt_local.wrap = false       -- 禁用自动换行
					vim.opt_local.conceallevel = 2   -- 启用文本隐藏（用于渲染）

					-- MDX 使用 markdown 解析器进行语法高亮
					-- 因为 MDX = Markdown + JSX，我们使用 markdown 解析器
					vim.bo.syntax = 'markdown'
					vim.treesitter.start(0, 'markdown')

					-- ============================================================
					-- 启用 TypeScript LSP（支持 MDX）
					-- TypeScript LSP 可以处理 MDX 中的 JSX/TSX 语法
					-- 需要先安装：:MasonInstall typescript-language-server
					-- ============================================================
					vim.lsp.enable('ts_ls')

					-- ============================================================
					-- 可选：启用 Marksman LSP（Markdown 语言服务器）
					-- 提供 Markdown 链接补全、标题导航等功能
					-- 安装：:MasonInstall marksman
					-- ============================================================
					vim.lsp.enable('marksman')

					-- ============================================================
					-- 快捷键：gx - 智能打开 MDX/Markdown 链接
					-- ============================================================
					vim.keymap.set('n', 'gx', function()
						local line = vim.fn.getline('.')
						local cursor_col = vim.fn.col('.')
						local pos = 1

						while pos <= #line do
							local open_bracket = line:find('%[', pos)
							if not open_bracket then break end

							local close_bracket = line:find('%]', open_bracket + 1)
							if not close_bracket then break end

							local open_paren = line:find('%(', close_bracket + 1)
							if not open_paren then break end

							local close_paren = line:find('%)', open_paren + 1)
							if not close_paren then break end

							if (cursor_col >= open_bracket and cursor_col <= close_bracket)
								or (cursor_col >= open_paren and cursor_col <= close_paren) then
								local url = line:sub(open_paren + 1, close_paren - 1)
								vim.ui.open(url)
								return
							end

							pos = close_paren + 1
						end

						-- 如果不在链接上，使用默认的 gx 行为
						vim.cmd('normal! gx')
					end, { buffer = true, desc = 'Smart URL opener for MDX' })
				end,
			})
		end,
	},

	-- ========================================================================
	-- 可选：为 MDX 启用 render-markdown 渲染
	-- 如果你想在 MDX 文件中也看到美化的 Markdown 渲染
	-- ========================================================================
	{
		"MeanderingProgrammer/render-markdown.nvim",
		optional = true,
		opts = function(_, opts)
			-- 将 mdx 添加到支持的文件类型列表
			opts.file_types = opts.file_types or { "markdown" }
			vim.list_extend(opts.file_types, { "mdx" })
		end,
	},
}
