-- ============================================================================
-- Tabline 配置文件
-- 使用 bufferline.nvim 插件美化 Neovim 顶部的 Tab/Buffer 栏
-- GitHub: akinsho/bufferline.nvim
-- ============================================================================

return {
	-- 插件地址
	'akinsho/bufferline.nvim',

	-- 依赖插件：文件图标支持
	-- 让 Tab 栏显示文件类型对应的图标
	dependencies = 'nvim-tree/nvim-web-devicons',

	-- ========================================================================
	-- 插件配置选项
	-- opts = {} 是 lazy.nvim 的简写形式
	-- 等同于 config = function() require('bufferline').setup({...}) end
	-- ========================================================================
	opts = {
		options = {
		-- ========================================================================
			-- ================================================================
			-- 显示模式
			-- ================================================================
			-- "tabs"    : 只显示 Tab 页（类似传统编辑器的标签页）
			-- "buffers" : 显示所有打开的 Buffer（类似 VS Code）
			mode = "tabs",

			-- ================================================================
			-- LSP 诊断集成
			-- ================================================================
			-- 在 Tab 上显示该文件的 LSP 诊断信息（错误、警告数量）
			-- 可选值:
			--   false      : 不显示
			--   "nvim_lsp" : 使用 Neovim 内置 LSP
			--   "coc"      : 使用 coc.nvim
			diagnostics = "nvim_lsp",

			-- 自定义诊断信息的显示格式
			-- 参数说明:
			--   count            : 诊断数量
			--   level            : 诊断级别 ("error", "warning", "info", "hint")
			--   diagnostics_dict : 包含各级别诊断数量的表
			--   context          : 上下文信息
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				-- 根据级别选择图标：错误用 ，其他用 
				local icon = level:match("error") and " " or " "
				-- 返回格式: " 图标 数量"
				return " " .. icon .. count
			end,

			-- ================================================================
			-- 指示器样式（当前选中 Tab 的标记）
			-- ================================================================
			indicator = {
				-- 指示器图标（竖线）
				-- 只有当 style = "icon" 时才会显示
				icon = '▎',

				-- 指示器样式
				-- "icon"      : 在 Tab 左侧显示竖线图标
				-- "underline" : 在 Tab 下方显示下划线
				-- "none"      : 不显示指示器
				style = "icon",
			},

			-- 是否在每个 Tab 上显示关闭按钮 (×)
			show_buffer_close_icons = false,

			-- 是否在 Tab 栏最右侧显示全局关闭按钮
			show_close_icon = true,

			-- 强制所有 Tab 使用相同宽度
			-- true  : 所有 Tab 等宽
			-- false : Tab 宽度根据文件名长度自适应
			enforce_regular_tabs = true,

			-- 当有重复文件名时，是否显示目录前缀以区分
			-- true  : 显示 "src/index.js" 和 "lib/index.js"
			-- false : 都只显示 "index.js"
			show_duplicate_prefix = false,

			-- 每个 Tab 的宽度（字符数）
			-- 只有当 enforce_regular_tabs = true 时生效
			tab_size = 16,

			-- Tab 内部的左右内边距
			padding = 0,

			-- ================================================================
			-- 分隔符样式
			-- ================================================================
			-- Tab 之间的分隔符样式
			-- 可选值:
			--   "slant"     : 斜线 /\
			--   "padded_slant" : 带间距的斜线
			--   "slope"     : 斜坡样式
			--   "padded_slope" : 带间距的斜坡
			--   "thick"     : 粗线分隔
			--   "thin"      : 细线分隔
			--   { '|', '|' } : 自定义字符 {左分隔符, 右分隔符}
			separator_style = "thick",
		}
	}
}
