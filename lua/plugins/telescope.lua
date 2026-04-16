-- ============================================================================
-- Telescope 配置文件
-- Telescope 是 Neovim 最流行的模糊查找器插件
-- ============================================================================

-- 快捷键通用选项
-- noremap: 非递归映射，避免映射冲突
-- nowait: 不等待后续按键，立即执行
local m = { noremap = true, nowait = true }

-- ============================================================================
-- 插件配置列表
-- ============================================================================
return {
	-- ========================================================================
	-- 插件 1: Telescope 主插件
	-- GitHub: nvim-telescope/telescope.nvim
	-- 功能: 提供模糊搜索界面，可搜索文件、Buffer、命令、Git 等
	-- ========================================================================
	{
		"nvim-telescope/telescope.nvim",

		-- --------------------------------------------------------------------
		-- 依赖插件列表
		-- 这些插件会在 Telescope 加载前自动安装和加载
		-- --------------------------------------------------------------------
		dependencies = {
			-- 文件图标支持，让文件列表显示对应的图标
			"nvim-tree/nvim-web-devicons",

			-- Lua 工具函数库，Telescope 的必需依赖
			"nvim-lua/plenary.nvim",

			-- Tab 页搜索扩展
			-- 允许用 Telescope 搜索和切换 Tab 页
			{
				"LukasPietzschmann/telescope-tabs",
				config = function()
					local tstabs = require('telescope-tabs')
					tstabs.setup({})
					-- Ctrl+t: 列出所有 Tab 页
					vim.keymap.set('n', '<c-t>', tstabs.list_tabs, {})
				end
			},

			-- fzf 原生排序算法（C 语言实现）
			-- 比默认的 Lua 实现快很多
			-- build = 'make': 安装时需要编译
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

			-- UI 美化插件
			-- 让 vim.ui.select 和 vim.ui.input 使用更好看的界面
			'stevearc/dressing.nvim',
		},

		-- --------------------------------------------------------------------
		-- 插件配置函数
		-- 在插件加载完成后执行
		-- --------------------------------------------------------------------
		config = function()
			-- 引入 Telescope 内置搜索器
			local builtin = require('telescope.builtin')

			-- ================================================================
			-- 快捷键设置
			-- ================================================================

			-- Ctrl+p: 搜索项目文件（类似 VS Code）
			vim.keymap.set('n', '<c-p>', builtin.find_files, m)

			-- <Leader>rs: 恢复上次搜索结果
			-- 适用于意外关闭搜索窗口后想继续查看结果
			vim.keymap.set('n', '<leader>rs', builtin.resume, m)

			-- Ctrl+w: 搜索已打开的 Buffer
			vim.keymap.set('n', '<c-w>', builtin.buffers, m)

			-- Ctrl+h: 搜索最近打开的文件（历史记录）
			vim.keymap.set('n', '<c-h>', builtin.oldfiles, m)

			-- Ctrl+/: 在当前文件内模糊搜索
			-- 注意: <c-_> 在终端中代表 Ctrl+/
			vim.keymap.set('n', '<c-_>', builtin.current_buffer_fuzzy_find, m)

			-- z=: 拼写建议（替代 Vim 默认的拼写建议界面）
			vim.keymap.set('n', 'z=', builtin.spell_suggest, m)

			-- <Leader>d: 显示诊断信息（错误、警告等）
			-- 按严重程度排序，错误在最前面
			vim.keymap.set('n', '<leader>d', function()
				builtin.diagnostics({
					sort_by = "severity"
				})
			end, m)

			-- ================================================================
			-- 诊断严重程度定义
			-- 用于 LSP 诊断信息的级别排序
			-- ================================================================

			-- LSP 协议的诊断严重程度
			vim.lsp.protocol.DiagnosticSeverity = {
				"Error",       -- 1: 错误（最严重）
				"Warning",     -- 2: 警告
				"Information", -- 3: 信息
				"Hint",        -- 4: 提示（最轻微）
				Error = 1,
				Hint = 4,
				Information = 3,
				Warning = 2
			}

			-- Neovim 内置诊断严重程度
			vim.diagnostic.severity = {
				"ERROR",
				"WARN",
				"INFO",
				"HINT",
				E = 1,
				ERROR = 1,
				HINT = 4,
				I = 3,
				INFO = 3,
				N = 4,
				W = 2,
				WARN = 2
			}

			-- gi: 显示 Git 状态（已修改、新增、删除的文件）
			vim.keymap.set('n', 'gi', builtin.git_status, m)

			-- `:` 键: 用 Telescope 搜索命令（替代原生命令行）
			vim.keymap.set("n", ":", builtin.commands, m)

			-- ================================================================
			-- Telescope 核心设置
			-- ================================================================

			local ts = require('telescope')
			local actions = require('telescope.actions')

			ts.setup({
				-- ------------------------------------------------------------
				-- 默认配置（适用于所有搜索器）
				-- ------------------------------------------------------------
				defaults = {
					-- 忽略的文件/目录模式
					-- 搜索时会跳过匹配这些模式的路径
					file_ignore_patterns = {
						"node_modules",  -- Node.js 依赖目录
						"build",         -- 构建输出目录
						"dist",          -- 打包输出目录
					},

					-- ripgrep 搜索参数
					-- 用于全局文本搜索（grep）
					vimgrep_arguments = {
						"rg",              -- 使用 ripgrep 作为搜索引擎
						"--color=never",   -- 不输出颜色代码
						"--no-heading",    -- 不显示文件名标题
						"--with-filename", -- 显示文件名
						"--line-number",   -- 显示行号
						"--column",        -- 显示列号
						"--fixed-strings", -- 字面搜索（非正则表达式）
						"--smart-case",    -- 智能大小写（全小写则忽略大小写）
						"--trim",          -- 去除结果首尾空白
					},

					-- 窗口布局配置
					layout_config = {
						width = 0.9,   -- 窗口宽度占屏幕 90%
						height = 0.9,  -- 窗口高度占屏幕 90%
					},

					-- 插入模式下的快捷键映射
					mappings = {
						i = {
							-- Ctrl+h: 显示快捷键帮助
							["<C-h>"] = "which_key",

							-- Ctrl+u/e: 上下移动选择（自定义，可能适配特殊键盘布局）
							["<C-u>"] = "move_selection_previous",
							["<C-e>"] = "move_selection_next",

							-- Ctrl+l/y: 预览窗口上下滚动
							["<C-l>"] = "preview_scrolling_up",
							["<C-y>"] = "preview_scrolling_down",

							-- ESC: 直接关闭（不进入普通模式）
							["<esc>"] = "close",

							-- Ctrl+n/p: 浏览搜索历史
							["<C-n>"] = require('telescope.actions').cycle_history_next,
							["<C-p>"] = require('telescope.actions').cycle_history_prev,
						}
					},

					-- 外观设置
					color_devicons = true,              -- 彩色文件图标
					prompt_prefix = "🔍 ",              -- 搜索框前缀
					selection_caret = " ",             -- 选中项前的标记
					path_display = { "truncate" },      -- 路径过长时截断显示

					-- 预览器设置
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				},

				-- ------------------------------------------------------------
				-- 特定搜索器配置（Pickers）
				-- ------------------------------------------------------------
				pickers = {
					-- find_files 搜索器配置
					find_files = {
						-- 使用 fd 命令搜索文件（比 find 更快）
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },

						-- 普通模式下的自定义映射
						mappings = {
							n = {
								-- 输入 "cd": 切换工作目录到选中文件所在目录
								["cd"] = function(prompt_bufnr)
									local selection = require("telescope.actions.state").get_selected_entry()
									local dir = vim.fn.fnamemodify(selection.path, ":p:h")
									require("telescope.actions").close(prompt_bufnr)
									vim.cmd(string.format("silent lcd %s", dir))
								end
							}
						}
					},

					-- buffers 搜索器配置
					buffers = {
						show_all_buffers = true,   -- 显示所有 buffer（包括未列出的）
						sort_lastused = true,      -- 按最近使用时间排序

						mappings = {
							i = {
								-- Ctrl+d: 删除选中的 buffer
								["<c-d>"] = actions.delete_buffer,
							},
						}
					},
				},

				-- ------------------------------------------------------------
				-- 扩展配置
				-- ------------------------------------------------------------
				extensions = {
					-- fzf 扩展配置
					fzf = {
						fuzzy = true,                    -- 启用模糊匹配
						override_generic_sorter = true,  -- 替换默认排序器
						override_file_sorter = true,     -- 替换文件排序器
						case_mode = "smart_case",        -- 智能大小写
					},
				}
			})

			-- ================================================================
			-- Dressing.nvim 配置
			-- 美化 vim.ui.select 和 vim.ui.input 的界面
			-- ================================================================
			require('dressing').setup({
				select = {
					get_config = function(opts)
						-- 当显示 LSP Code Action 时，使用 Telescope 的 cursor 主题
						-- cursor 主题: 在光标位置弹出小窗口
						if opts.kind == 'codeaction' then
							return {
								backend = 'telescope',
								telescope = require('telescope.themes').get_cursor()
							}
						end
					end
				}
			})

			-- ================================================================
			-- 加载 Telescope 扩展
			-- ================================================================

			-- telescope-tabs: Tab 页搜索
			ts.load_extension('telescope-tabs')

			-- fzf: 高性能模糊搜索算法
			ts.load_extension('fzf')
		end
	},

	-- ========================================================================
	-- 插件 2: Commander 命令面板
	-- GitHub: FeiyouG/commander.nvim
	-- 功能: 提供类似 VS Code 的命令面板（Ctrl+Shift+P）
	-- ========================================================================
	{
		"FeiyouG/commander.nvim",
		config = function()
			local commander = require("commander")

			-- 基本设置
			commander.setup({
				telescope = {
					enable = true,  -- 使用 Telescope 作为 UI 后端
				},
			})

			-- Ctrl+q: 打开命令面板
			vim.keymap.set('n', '<c-q>', require("commander").show, m)

			-- 添加自定义命令
			commander.add({
				{
					desc = "Git diff",                       -- 命令描述（显示在面板中）
					cmd = "<CMD>Telescope git_status<CR>",   -- 执行的 Vim 命令
				},
			})
		end
	}
}
