-- ============================================================================
-- 状态栏配置文件
-- 使用 lualine.nvim 插件美化 Neovim 底部的状态栏
-- GitHub: nvim-lualine/lualine.nvim
-- ============================================================================

-- ============================================================================
-- 被注释掉的功能：LSP 签名显示
-- 如果启用，可以在状态栏显示当前函数的参数提示
-- ============================================================================
-- local current_signature = function()
--     -- 检查是否安装了 lsp_signature 插件
--     if not pcall(require, 'lsp_signature') then return end
--     -- 获取当前函数签名，最大宽度 50 字符
--     local sig = require("lsp_signature").status_line(50)
--     -- 返回格式: "函数签名🐼参数提示"
--     return sig.label .. "🐼" .. sig.hint
-- end

return {
	-- 被注释掉的备选插件
	-- "theniceboy/eleline.vim",  -- 另一个状态栏插件
	-- branch = "no-scrollbar",   -- 使用无滚动条分支

	-- 插件地址
	"nvim-lualine/lualine.nvim",

	-- 被注释掉的懒加载选项
	-- event = "UiEnter",  -- 在 UI 加载完成后再加载此插件

	-- ========================================================================
	-- 插件配置函数
	-- ========================================================================
	config = function()
		require('lualine').setup {
			-- ================================================================
			-- 全局选项
			-- ================================================================
			options = {
				-- 是否启用图标（需要 Nerd Font 字体支持）
				icons_enabled = true,

				-- 主题设置
				-- 'auto': 自动匹配当前 colorscheme
				-- 也可以指定具体主题如 'gruvbox', 'dracula', 'tokyonight' 等
				theme = 'auto',

				-- 组件之间的分隔符
				-- left: 组件左侧的分隔符
				-- right: 组件右侧的分隔符
				-- '' 和 '' 是 Nerd Font 的圆角分隔符
				component_separators = { left = '', right = '' },

				-- 区域之间的分隔符（比组件分隔符更大）
				-- '' 和 '' 是 Nerd Font 的三角形分隔符
				section_separators = { left = '', right = '' },

				-- 禁用状态栏的文件类型
				-- 例如可以添加 'NvimTree', 'toggleterm' 等
				disabled_filetypes = {
					statusline = {},  -- 禁用状态栏的文件类型列表
					winbar = {},      -- 禁用 winbar 的文件类型列表
				},

				-- 忽略焦点的文件类型
				-- 这些文件类型的窗口即使获得焦点也使用 inactive 样式
				ignore_focus = {},

				-- 是否始终在中间分割
				-- true: 即使某一侧为空，也保持中间对齐
				always_divide_middle = true,

				-- 全局状态栏
				-- true: 所有窗口共享一个状态栏（在最底部）
				-- false: 每个窗口有自己的状态栏
				globalstatus = true,

				-- 刷新间隔（毫秒）
				refresh = {
					statusline = 1000,  -- 状态栏每 1 秒刷新一次
					tabline = 1000,     -- 标签栏每 1 秒刷新一次
					winbar = 1000,      -- winbar 每 1 秒刷新一次
				}
			},

			-- ================================================================
			-- 活动窗口的状态栏布局
			-- ================================================================
			--
			-- 状态栏分为 6 个区域：
			-- +---------------------------------------------------------+
			-- | A | B | C                             X | Y | Z |
			-- +---------------------------------------------------------+
			--
			-- A: 最左侧（通常是模式或文件名）
			-- B: 左侧第二区域（通常是 Git 信息）
			-- C: 左侧第三区域（可放额外信息）
			-- X: 右侧第三区域（可放额外信息）
			-- Y: 右侧第二区域（通常是文件信息）
			-- Z: 最右侧（通常是位置信息）
			--
			sections = {
				-- 区域 A: 显示文件名


				-- 区域 B: 显示 Git 分支、diff 统计、诊断信息
				-- 'branch'     : 当前 Git 分支名
				-- 'diff'       : 文件修改统计 (+增加 ~修改 -删除)
				-- 'diagnostics': LSP 诊断 (错误/警告/提示数量)
				lualine_b = { 'branch', 'diff', 'diagnostics' },

				-- 区域 C: 空（可以添加自定义组件）
				lualine_c = {},

				-- 区域 X: 空（可以添加自定义组件）
				lualine_x = {},

				-- 区域 Y: 显示文件大小、文件格式、文件类型
				-- 'filesize'  : 文件大小 (如 "1.2KB")
				-- 'fileformat': 文件格式 (unix/dos/mac)
				-- 'filetype'  : 文件类型 (如 "lua", "python")
				lualine_y = { 'filesize', 'fileformat', 'filetype' },

				-- 区域 Z: 显示光标位置
				-- 'location': 显示行号和列号 (如 "42:15")
				lualine_z = { 'location' }
			},

			-- ================================================================
			-- 非活动窗口的状态栏布局
			-- 当 globalstatus = true 时，此设置基本不生效
			-- ================================================================
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { 'filename' },  -- 只显示文件名
				lualine_x = { 'location' },  -- 只显示位置
				lualine_y = {},
				lualine_z = {}
			},

			-- ================================================================
			-- 其他栏位配置
			-- ================================================================

			-- 标签栏（顶部）
			-- 留空表示不使用 lualine 管理标签栏
			-- 你已经用 bufferline.nvim 管理了
			tabline = {},

			-- Winbar（窗口顶部的状态栏，Neovim 0.8+）
			winbar = {},

			-- 非活动窗口的 Winbar
			inactive_winbar = {},

			-- 扩展支持
			-- 为特定插件提供状态栏集成，如:
			-- 'nvim-tree', 'toggleterm', 'quickfix', 'fugitive' 等
			extensions = {}
		}
	end
}
