-- ============================================================================
-- Mini.nvim 配置文件
-- mini.nvim 是一个模块化的 Neovim 插件集合
-- GitHub: https://github.com/echasnovski/mini.nvim
-- ============================================================================
--
-- 本配置使用的模块：
-- • mini.ai       - 增强文本对象
-- • mini.icons    - 文件图标
-- • mini.surround - 包围符号操作
--
-- ============================================================================

return {
	-- ========================================================================
	-- Mini.nvim 主插件
	-- 包含所有 mini.* 模块，按需加载
	-- ========================================================================
	{
		"echasnovski/mini.nvim",
		version = false,  -- 使用最新版本，不锁定 tag

		-- 立即加载（因为 mini.ai 和 mini.surround 是常用编辑功能）
		lazy = false,

		config = function()
			-- ================================================================
			-- 模块 1: mini.ai
			-- 功能：增强 Neovim 的文本对象（text objects）
			-- ================================================================
			--
			-- 什么是文本对象？
			-- 在 Vim 中，d/c/y 等操作可以配合文本对象使用：
			-- - diw : 删除一个单词
			-- - ci" : 修改双引号内的内容
			-- - ya( : 复制包含括号的内容
			--
			-- mini.ai 增强了这些功能，提供：
			-- - 更多文本对象（函数参数、函数体、注释等）
			-- - 跳转到上一个/下一个文本对象
			-- - 更智能的边界检测
			--
			-- 内置文本对象：
			-- ┌────────┬────────────────────────────────────────┐
			-- │ 按键   │ 文本对象                               │
			-- ├────────┼────────────────────────────────────────┤
			-- │ (  )   │ 圆括号                                 │
			-- │ [  ]   │ 方括号                                 │
			-- │ {  }   │ 花括号                                 │
			-- │ <  >   │ 尖括号                                 │
			-- │ "      │ 双引号                                 │
			-- │ '      │ 单引号                                 │
			-- │ `      │ 反引号                                 │
			-- │ q      │ 引号（自动检测 " ' `）                  │
			-- │ b      │ 括号（自动检测 () [] {}）              │
			-- │ t      │ HTML/XML 标签                          │
			-- │ f      │ 函数调用（如 func(...)）               │
			-- │ a      │ 函数参数                               │
			-- │ ?      │ 用户输入的字符                         │
			-- └────────┴────────────────────────────────────────┘
			--
			-- 使用示例：
			-- ┌─────────────────────────────────────────────────┐
			-- │ function hello(name, age) {                    │
			-- │     return "Hello, " + name;                   │
			-- │ }                      ↑                       │
			-- │                     光标在这里                  │
			-- │                                                 │
			-- │ dia  → 删除当前参数 "name"                      │
			-- │ ci"  → 修改引号内的 "Hello, "                   │
			-- │ daf  → 删除整个函数调用                         │
			-- │ ]a   → 跳转到下一个参数 "age"                   │
			-- └─────────────────────────────────────────────────┘
			--
			require("mini.ai").setup({
				-- 自定义映射
				mappings = {
					-- 跳转到上一个/下一个文本对象
					-- 用法：[a 跳转到上一个参数，]a 跳转到下一个参数
					-- [f 跳转到上一个函数，]f 跳转到下一个函数
					goto_left = "[",   -- 向左（上一个）跳转的前缀键
					goto_right = "]",  -- 向右（下一个）跳转的前缀键
				},

				-- 可选：自定义文本对象
				-- custom_textobjects = {
				--     -- 定义 'e' 为整个 buffer
				--     e = function()
				--         local from = { line = 1, col = 1 }
				--         local to = {
				--             line = vim.fn.line('$'),
				--             col = math.max(vim.fn.getline('$'):len(), 1)
				--         }
				--         return { from = from, to = to }
				--     end,
				-- },

				-- 搜索方法
				-- 'cover_or_next' : 优先覆盖光标，否则找下一个
				-- 'cover'         : 只覆盖光标
				-- 'next'          : 只找下一个
				-- 'prev'          : 只找上一个
				-- search_method = 'cover_or_next',

				-- 搜索的行数范围（0 = 无限制）
				-- n_lines = 50,
			})

			-- ================================================================
			-- 模块 2: mini.icons
			-- 功能：提供文件/目录/文件类型的图标
			-- ================================================================
			--
			-- 这个模块为各种插件提供图标支持，如：
			-- - 文件浏览器（nvim-tree, neo-tree）
			-- - 模糊查找器（telescope, fzf-lua）
			-- - 状态栏（lualine）
			-- - 标签栏（bufferline）
			-- - 等等...
			--
			-- 与 nvim-web-devicons 的区别：
			-- - mini.icons 更轻量
			-- - 支持更多图标类型（目录、操作系统、LSP 类型等）
			-- - 可以作为 nvim-web-devicons 的替代品
			--
			require("mini.icons").setup({
				-- 图标风格
				-- "glyph" : 使用 Nerd Font 图标（需要安装 Nerd Font）
				-- "ascii" : 使用 ASCII 字符（不需要特殊字体）
				style = "glyph",

				-- 自定义特定文件的图标
				file = {
					-- README 文件使用书本图标，黄色高亮
					README = { glyph = "󰆈", hl = "MiniIconsYellow" },
					["README.md"] = { glyph = "󰆈", hl = "MiniIconsYellow" },
				},

				-- 自定义特定文件类型的图标
				filetype = {
					-- Bash 脚本使用终端图标，绿色高亮
					bash = { glyph = "󱆃", hl = "MiniIconsGreen" },
					-- Shell 脚本使用终端图标，灰色高亮
					sh = { glyph = "󱆃", hl = "MiniIconsGrey" },
					-- TOML 文件使用配置图标，橙色高亮
					toml = { glyph = "󱄽", hl = "MiniIconsOrange" },
				},

				-- 可选：自定义目录图标
				-- directory = {
				--     [".git"] = { glyph = "", hl = "MiniIconsOrange" },
				--     ["node_modules"] = { glyph = "", hl = "MiniIconsGreen" },
				-- },

				-- 可选：自定义扩展名图标
				-- extension = {
				--     ["txt"] = { glyph = "󰈙", hl = "MiniIconsYellow" },
				-- },
			})

			-- 可选：让 mini.icons 作为 nvim-web-devicons 的后备
			-- 这样其他依赖 nvim-web-devicons 的插件也能正常工作
			-- MiniIcons.mock_nvim_web_devicons()

			-- ================================================================
			-- 模块 3: mini.surround
			-- 功能：快速添加/删除/替换包围符号（引号、括号等）
			-- ================================================================
			--
			-- 这是类似 vim-surround 的功能，但更现代化
			--
			-- 使用示例：
			-- ┌─────────────────────────────────────────────────────────────┐
			-- │ 操作        │ 输入前           │ 输入后                     │
			-- ├─────────────┼──────────────────┼────────────────────────────┤
			-- │ saiw"       │ hello            │ "hello"                    │
			-- │ saiw)       │ hello            │ (hello)                    │
			-- │ saiw}       │ hello            │ {hello}                    │
			-- │ saiw>       │ hello            │ <hello>                    │
			-- │ saiwt       │ hello            │ <tag>hello</tag> (输入tag) │
			-- ├─────────────┼──────────────────┼────────────────────────────┤
			-- │ sd"         │ "hello"          │ hello                      │
			-- │ sd(         │ (hello)          │ hello                      │
			-- │ sdt         │ <p>hello</p>     │ hello                      │
			-- ├─────────────┼──────────────────┼────────────────────────────┤
			-- │ sr"'        │ "hello"          │ 'hello'                    │
			-- │ sr({        │ (hello)          │ {hello}                    │
			-- │ sr"t        │ "hello"          │ <tag>hello</tag>           │
			-- └─────────────┴──────────────────┴────────────────────────────┘
			--
			-- 助记方式：
			-- s  = surround（包围）
			-- a  = add（添加）
			-- d  = delete（删除）
			-- r  = replace（替换）
			-- f  = find（查找）
			-- h  = highlight（高亮）
			--
			-- 可视模式：
			-- 选中文本后按 sa" 可以给选中内容添加双引号
			--
			require("mini.surround").setup({
				mappings = {
					-- 添加包围符号
					-- 普通模式：sa{motion}{char}，如 saiw" 给单词添加双引号
					-- 可视模式：选中后 sa{char}，如 sa" 给选中内容添加双引号
					add = "sa",

					-- 删除包围符号
					-- sd{char}，如 sd" 删除周围的双引号
					delete = "sd",

					-- 查找包围符号（向右查找）
					-- sf{char}，如 sf" 跳转到下一个双引号
					find = "sf",

					-- 查找包围符号（向左查找）
					-- sF{char}，如 sF" 跳转到上一个双引号
					find_left = "sF",

					-- 高亮包围符号
					-- sh{char}，如 sh" 高亮周围的双引号
					highlight = "sh",

					-- 替换包围符号
					-- sr{old}{new}，如 sr"' 将双引号替换为单引号
					replace = "sr",

					-- 更新 n_lines 配置
					-- sn 后输入数字，设置搜索范围的行数
					update_n_lines = "sn",

					-- 搜索方法的后缀
					-- 用于指定搜索方向
					suffix_last = "l",  -- 向后（上一个），如 sdl" 删除上一个双引号
					suffix_next = "n",  -- 向前（下一个），如 sdn" 删除下一个双引号
				},

				-- 搜索的行数范围
				-- n_lines = 20,

				-- 是否高亮持续时间（毫秒）
				-- highlight_duration = 500,

				-- 是否尊重选择类型（字符/行/块）
				-- respect_selection_type = false,
			})
		end,
	},
}
