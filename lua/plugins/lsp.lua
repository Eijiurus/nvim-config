-- ============================================================================
-- LSP 配置文件
-- 使用 nvim-lspconfig 配置语言服务器
-- 使用 mason.nvim 管理语言服务器的安装
-- ============================================================================
--
-- 本配置启用的 LSP：
-- ┌─────────────┬────────────────────────────────────────┐
-- │ LSP 名称    │ 用途                                   │
-- ├─────────────┼────────────────────────────────────────┤
-- │ clangd      │ C/C++ 语言服务器                       │
-- │ lua_ls      │ Lua 语言服务器                         │
-- │ stylua      │ Lua 格式化工具                         │
-- │ pylsp       │ Python 语言服务器                      │
-- │ ruff        │ Python 快速 linter/formatter          │
-- │ texlab      │ LaTeX 语言服务器                       │
-- │ tinymist    │ Typst 语言服务器                       │
-- │ typstyle    │ Typst 格式化工具                       │
-- │ ts_ls       │ TypeScript/JavaScript 语言服务器(MDX)  │
-- │ marksman    │ Markdown 语言服务器 (Markdown/MDX)     │
-- └─────────────┴────────────────────────────────────────┘
--
-- ============================================================================

return {
	-- ========================================================================
	-- 插件 1: mason.nvim
	-- GitHub: mason-org/mason.nvim
	-- 功能：LSP/DAP/Linter/Formatter 的包管理器
	-- ========================================================================
	--
	-- Mason 是什么？
	-- 类似于 LSP 的 "应用商店"，可以方便地安装和管理：
	-- - 语言服务器（LSP）
	-- - 调试适配器（DAP）
	-- - 代码检查器（Linter）
	-- - 格式化工具（Formatter）
	--
	-- 使用方法：
	-- :Mason        打开 Mason 界面
	-- :MasonInstall 安装指定包
	-- :MasonUpdate  更新所有包
	--
	{
		"mason-org/mason.nvim",
		-- 优先加载，因为其他 LSP 配置依赖它
		priority = 100,
		config = function()
			require("mason").setup({
				-- 可选配置
				ui = {
					-- Mason 界面的图标
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end
	},

	-- ========================================================================
	-- 插件 2: nvim-lspconfig
	-- GitHub: neovim/nvim-lspconfig
	-- 功能：提供常用语言服务器的默认配置
	-- ========================================================================
	{
		"neovim/nvim-lspconfig",
		-- 依赖 mason.nvim
		dependencies = { "mason-org/mason.nvim" },
		-- 在打开文件时加载
		event = { "BufReadPre", "BufNewFile" },

		config = function()
			-- ================================================================
			-- 启用语言服务器
			-- ================================================================
			-- vim.lsp.enable() 是 Neovim 0.11+ 的新 API
			-- 它会自动使用 nvim-lspconfig 中的默认配置启动 LSP
			--
			-- 注意：需要先通过 Mason 安装这些 LSP
			-- :MasonInstall clangd lua-language-server python-lsp-server 等

			-- C/C++ 语言服务器
			-- 提供：补全、跳转、诊断、格式化等
			vim.lsp.enable("clangd")

			-- Lua 语言服务器
			-- 专门为 Neovim Lua 配置优化
			vim.lsp.enable("lua_ls")

			-- Lua 格式化工具（通过 LSP 协议）
			vim.lsp.enable("stylua")

			-- Python 语言服务器
			-- 提供：补全、跳转、诊断等
			vim.lsp.enable("pylsp")

			-- Python 快速 linter/formatter
			-- 比 pylsp 更快，专注于代码质量检查
			vim.lsp.enable("ruff")


			-- LaTeX 语言服务器
			-- 提供：补全、跳转、编译、预览等
			vim.lsp.enable("texlab")

			-- Typst 语言服务器
			-- 提供：补全、跳转、诊断、导出 PDF 等
			vim.lsp.enable("tinymist")

			-- TypeScript/JavaScript 语言服务器
			-- 提供：补全、跳转、诊断等（也支持 MDX）
			vim.lsp.enable("ts_ls")


			-- ================================================================
			-- LSP 附加时的配置（LspAttach 自动命令）
			-- ================================================================
			-- 当 LSP 连接到 buffer 时，设置快捷键和功能
			--
			vim.api.nvim_create_autocmd("LspAttach", {
				-- 创建自动命令组，便于管理
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),

				-- 回调函数，每次 LSP 附加时执行
				callback = function(event)
					-- 获取当前 LSP 客户端
					local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
					-- 当前 buffer
					local buf = event.buf

					-- ========================================================
					-- 功能 1: Inlay Hints（内联提示）
					-- ========================================================
					-- Inlay Hints 是什么？
					-- 在代码中内联显示类型信息、参数名等提示
					--
					-- 示例：
					--   let x = 1 + 2
					--       ↓ 启用 Inlay Hints 后
					--   let x: i32 = 1 + 2
					--          ^^^^ 这是内联提示
					--
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						-- <Leader>th : 切换 Inlay Hints 显示
						vim.keymap.set('n', '<leader>th', function()
							-- 切换当前 buffer 的 Inlay Hints
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
							)
						end, { buffer = buf, desc = 'LSP: Toggle Inlay Hints' })
					end

					-- ========================================================
					-- 功能 2: LSP 折叠
					-- ========================================================
					-- 使用 LSP 提供的折叠范围，比基于缩进的折叠更智能
					--
					if client and client:supports_method('textDocument/foldingRange') then
						local win = vim.api.nvim_get_current_win()
						-- 设置折叠表达式为 LSP 折叠
						vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
					end

					-- ========================================================
					-- 功能 3: 快捷键映射
					-- ========================================================

					-- --------------------------------------------------------
					-- <Leader>lf : 格式化代码
					-- --------------------------------------------------------
					vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {
						buffer = buf,
						desc = "LSP: Format buffer"
					})

					-- --------------------------------------------------------
					-- gd : 跳转到定义
					-- --------------------------------------------------------
					-- 如果找到定义，使用 snacks.picker 显示
					-- 如果没找到，显示通知
					--
					vim.keymap.set("n", "gd", function()
						-- 获取当前光标位置的参数
						local params = vim.lsp.util.make_position_params(0, "utf-8")

						-- 向 LSP 请求定义位置
						vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
							if not result or vim.tbl_isempty(result) then
								-- 没有找到定义
								vim.notify("No definition found", vim.log.levels.INFO)
							else
								-- 找到定义，使用 snacks.picker 显示
								-- 如果你没有安装 snacks.nvim，可以改用：
								-- vim.lsp.buf.definition()
								require("snacks").picker.lsp_definitions()
							end
						end)
					end, { buffer = buf, desc = "LSP: Goto Definition" })

					-- --------------------------------------------------------
					-- gD : 在分割窗口中跳转到定义
					-- --------------------------------------------------------
					-- 智能选择分割方向：
					-- - 如果窗口宽度足够，垂直分割（左右）
					-- - 如果窗口高度足够，水平分割（上下）
					--
					vim.keymap.set("n", "gD", function()
						local win = vim.api.nvim_get_current_win()
						local width = vim.api.nvim_win_get_width(win)
						local height = vim.api.nvim_win_get_height(win)

						-- 计算公式：8 * width - 20 * height
						-- 这个公式模仿 tmux 的分割逻辑
						-- 正数 = 水平空间更多 → 垂直分割
						-- 负数 = 垂直空间更多 → 水平分割
						local value = 8 * width - 20 * height

						if value < 0 then
							-- 垂直空间更多，水平分割（上下）
							vim.cmd("split")
						else
							-- 水平空间更多，垂直分割（左右）
							vim.cmd("vsplit")
						end

						-- 在新窗口中跳转到定义
						vim.lsp.buf.definition()
					end, { buffer = buf, desc = "LSP: Goto Definition (split)" })

					-- --------------------------------------------------------
					-- [f : 跳转到当前函数的开头
					-- --------------------------------------------------------
					-- 使用 LSP 的 documentSymbol 功能找到当前函数
					--
					local function jump_to_current_function_start()
						-- 请求当前文档的所有符号
						local params = { textDocument = vim.lsp.util.make_text_document_params() }
						-- 同步请求，超时 1000ms
						local responses = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, 1000)
						if not responses then return end

						-- 获取当前光标位置
						local pos = vim.api.nvim_win_get_cursor(0)
						local line = pos[1] - 1  -- 转为 0-indexed

						-- 递归查找包含当前行的符号
						-- 符号可能嵌套（如类中的方法）
						local function find_symbol(symbols)
							for _, s in ipairs(symbols) do
								local range = s.range or (s.location and s.location.range)
								-- 检查当前行是否在符号范围内
								if range and line >= range.start.line and line <= range["end"].line then
									-- 如果有子符号，先检查子符号（找最内层的）
									if s.children then
										local child = find_symbol(s.children)
										if child then return child end
									end
									return s
								end
							end
						end

						-- 遍历所有 LSP 响应
						for _, resp in pairs(responses) do
							local sym = find_symbol(resp.result or {})
							if sym and sym.range then
								-- 跳转到符号的起始行
								vim.api.nvim_win_set_cursor(0, { sym.range.start.line + 1, 0 })
								return
							end
						end
					end

					vim.keymap.set("n", "[f", jump_to_current_function_start, {
						buffer = buf,
						desc = "LSP: Jump to function start"
					})

					-- --------------------------------------------------------
					-- ]f : 跳转到当前函数的结尾
					-- --------------------------------------------------------
					local function jump_to_current_function_end()
						local params = { textDocument = vim.lsp.util.make_text_document_params() }
						local responses = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, 1000)
						if not responses then return end

						local pos = vim.api.nvim_win_get_cursor(0)
						local line = pos[1] - 1

						local function find_symbol(symbols)
							for _, s in ipairs(symbols) do
								local range = s.range or (s.location and s.location.range)
								if range and line >= range.start.line and line <= range["end"].line then
									if s.children then
										local child = find_symbol(s.children)
										if child then return child end
									end
									return s
								end
							end
						end

						for _, resp in pairs(responses) do
							local sym = find_symbol(resp.result or {})
							if sym and sym.range then
								-- 跳转到符号的结束行
								vim.api.nvim_win_set_cursor(0, { sym.range["end"].line + 1, 0 })
								return
							end
						end
					end

					vim.keymap.set("n", "]f", jump_to_current_function_end, {
						buffer = buf,
						desc = "LSP: Jump to function end"
					})

					-- ========================================================
					-- 可选：添加更多常用 LSP 快捷键
					-- ========================================================

					-- gr : 查找引用
					-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {
					--     buffer = buf,
					--     desc = "LSP: Find references"
					-- })

					-- K : 显示悬停信息
					-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {
					--     buffer = buf,
					--     desc = "LSP: Hover documentation"
					-- })

					-- <Leader>rn : 重命名符号
					-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
					--     buffer = buf,
					--     desc = "LSP: Rename symbol"
					-- })

					-- <Leader>ca : 代码操作
					-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
					--     buffer = buf,
					--     desc = "LSP: Code action"
					-- })

				end,  -- end of callback
			})

			-- ================================================================
			-- 可选：补全菜单设置
			-- ================================================================
			-- 取消注释以启用内置补全菜单
			-- vim.cmd([[set completeopt+=menuone,noselect,popup]])

		end,  -- end of config
	},
}
