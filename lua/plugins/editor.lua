-- ============================================================================
-- Editor 配置文件
-- 包含各种编辑器增强插件，提升编辑体验
-- ============================================================================

-- ============================================================================
-- 自定义 VimScript 函数：MakePair
-- 功能：将光标后的字符移动到行尾
-- ============================================================================
--
-- 使用场景示例：
-- 输入时：const foo = bar(baz|)   （| 表示光标位置）
-- 按 Ctrl+u 后：const foo = bar(baz)|
--
-- 如果行尾有 ; 或 , 则放在符号前面：
-- 输入时：const foo = bar(baz|);
-- 按 Ctrl+u 后：const foo = bar(baz);|
--
vim.cmd([[
fun! s:MakePair()
	let line = getline('.')           " 获取当前行内容
	let len = strlen(line)            " 获取行长度
	if line[len - 1] == ";" || line[len - 1] == ","
		" 如果行尾是 ; 或 , ，将字符放在符号前（P = 前插入）
		normal! lx$P
	else
		" 否则将字符放在行尾（p = 后插入）
		normal! lx$p
	endif
endfun
" 在插入模式下，Ctrl+u 调用此函数
inoremap <c-u> <ESC>:call <SID>MakePair()<CR>
]])


-- ============================================================================
-- 插件配置列表
-- ============================================================================
return {
	-- ========================================================================
	-- 插件 1: vim-illuminate
	-- GitHub: RRethy/vim-illuminate
	-- 功能：自动高亮光标下的单词及其所有匹配项
	-- ========================================================================
	--
	-- 效果示例：
	-- 当光标在 "foo" 上时，文件中所有的 "foo" 都会被高亮
	-- ┌────────────────────────────────────┐
	-- │ local [foo] = 1                    │  ← 光标所在
	-- │ print([foo])                       │  ← 自动高亮
	-- │ return [foo] + 1                   │  ← 自动高亮
	-- └────────────────────────────────────┘
	--
	{
		"RRethy/vim-illuminate",
		config = function()
			require('illuminate').configure({
				-- 高亮提供者（用于识别相同符号的方式）
				-- 'lsp'       : 使用 LSP 语义分析（最准确，但需要 LSP）
				-- 'treesitter': 使用 Treesitter 语法树（较准确）
				-- 'regex'     : 使用正则表达式匹配（最简单，但可能误匹配）
				-- 当前只启用了 regex，你可以根据需要启用其他提供者
				providers = {
					-- 'lsp',
					-- 'treesitter',
					'regex',
				},
			})

			-- 设置高亮样式
			-- guibg: 背景颜色（深灰色）
			-- gui=none: 无其他样式（如下划线、粗体等）
			vim.cmd("hi IlluminatedWordText guibg=#393E4D gui=none")
		end
	},

	-- ========================================================================
	-- 插件 2: bullets.vim
	-- GitHub: dkarter/bullets.vim
	-- 功能：智能处理 Markdown/文本文件中的列表项
	-- ========================================================================
	--
	-- 功能示例：
	-- 在列表项末尾按 Enter 时自动添加下一个列表符号
	-- - Item 1
	-- - Item 2|  ← 按 Enter
	-- - Item 3   ← 自动添加 "- "
	--
	-- 支持的列表类型：
	-- - 无序列表 (-, *, +)
	-- - 有序列表 (1., 2., 3.)
	-- - 复选框 (- [ ], - [x])
	--
	{
		"dkarter/bullets.vim",
		lazy = false,                    -- 不懒加载，立即加载
		ft = { "markdown", "txt" },      -- 只在 markdown 和 txt 文件中启用
	},

	-- ========================================================================
	-- 插件（已注释）: vim-smoothie
	-- GitHub: psliwka/vim-smoothie
	-- 功能：平滑滚动动画
	-- ========================================================================
	-- 被注释掉了，如果启用会让 Ctrl+e/u 有平滑滚动效果
	-- {
	-- 	"psliwka/vim-smoothie",
	-- 	init = function()
	-- 		vim.cmd([[nnoremap <unique> <C-e> <cmd>call smoothie#do("\<C-D>") <CR>]])
	-- 		vim.cmd([[nnoremap <unique> <C-u> <cmd>call smoothie#do("\<C-U>") <CR>]])
	-- 	end
	-- },

	-- ========================================================================
	-- 插件 3: nvim-colorizer.lua
	-- GitHub: NvChad/nvim-colorizer.lua
	-- 功能：在代码中直接显示颜色预览
	-- ========================================================================
	--
	-- 效果示例：
	-- color: #ff5733    ← 旁边会显示实际颜色方块 ■
	-- background: blue  ← 旁边会显示蓝色方块 ■
	--
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			-- 在所有文件类型中启用
			filetypes = { "*" },

			user_default_options = {
				-- 支持的颜色格式
				RGB = true,        -- 支持 #RGB 格式（如 #F00 = 红色）
				RRGGBB = true,     -- 支持 #RRGGBB 格式（如 #FF0000）
				names = true,      -- 支持颜色名称（如 "Blue", "red"）
				RRGGBBAA = false,  -- 不支持 #RRGGBBAA 格式（带透明度）
				AARRGGBB = true,   -- 支持 0xAARRGGBB 格式（Android 常用）
				rgb_fn = false,    -- 不支持 CSS rgb() 函数
				hsl_fn = false,    -- 不支持 CSS hsl() 函数
				css = false,       -- 不启用所有 CSS 功能
				css_fn = false,    -- 不启用 CSS 函数

				-- 颜色显示模式
				-- "foreground"  : 文字颜色变为该颜色
				-- "background"  : 文字背景变为该颜色
				-- "virtualtext" : 在文字后显示颜色方块
				mode = "virtualtext",

				-- 是否支持 Tailwind CSS 颜色类名
				-- 如 "text-red-500", "bg-blue-300" 等
				tailwind = true,

				-- Sass 颜色变量支持
				sass = { enable = false },

				-- virtualtext 模式下显示的字符
				virtualtext = "■",
			},

			-- Buffer 类型设置（留空使用默认）
			buftypes = {},
		}
	},

	-- ========================================================================
	-- 插件 4: antovim
	-- GitHub: theniceboy/antovim
	-- 功能：快速切换布尔值、是/否等对立词
	-- ========================================================================
	--
	-- 使用示例：
	-- 光标在 "true" 上按快捷键 → 变成 "false"
	-- 光标在 "yes" 上按快捷键 → 变成 "no"
	-- 光标在 "on" 上按快捷键 → 变成 "off"
	--
	{ 'theniceboy/antovim', lazy = false },

	-- ========================================================================
	-- 插件 5: wildfire.vim
	-- GitHub: gcmt/wildfire.vim
	-- 功能：快速选择文本对象（递增选择）
	-- ========================================================================
	--
	-- 使用示例：
	-- 在普通模式下按 Enter：
	-- 第 1 次：选中光标所在的单词
	-- 第 2 次：选中引号/括号内的内容
	-- 第 3 次：选中包含引号/括号的内容
	-- 第 4 次：继续扩大选择范围...
	--
	-- 示例：print("hello world")
	--        光标在 hello 上
	-- Enter x1: 选中 "hello"
	-- Enter x2: 选中 "hello world"
	-- Enter x3: 选中 "hello world" (含引号)
	-- Enter x4: 选中整个 print(...)
	--
	{ 'gcmt/wildfire.vim', lazy = false },

	-- ========================================================================
	-- 插件 6: move.nvim
	-- GitHub: fedepujol/move.nvim
	-- 功能：快速移动行或选中的代码块
	-- ========================================================================
	--
	-- 效果示例：
	-- 选中几行代码，按 Ctrl+e 向下移动，按 Ctrl+u 向上移动
	-- 移动时会自动调整缩进
	--
	{
		"fedepujol/move.nvim",
		config = function()
			require('move').setup({
				-- 行移动设置
				line = {
					enable = true,   -- 启用行移动
					indent = true    -- 移动时自动调整缩进
				},
				-- 块移动设置（可视模式下选中的多行）
				block = {
					enable = true,   -- 启用块移动
					indent = true    -- 移动时自动调整缩进
				},
				-- 单词移动（水平方向）
				word = {
					enable = false,  -- 禁用单词移动
				},
				-- 字符移动
				char = {
					enable = false   -- 禁用字符移动
				}
			})

			local opts = { noremap = true, silent = true }

			-- ================================================================
			-- 普通模式快捷键
			-- ================================================================
			-- Ctrl+y : 将当前行向下移动一行
			vim.keymap.set('n', '<c-y>', ':MoveLine(1)<CR>', opts)

			-- Ctrl+l : 将当前行向上移动一行
			vim.keymap.set('n', '<c-l>', ':MoveLine(-1)<CR>', opts)

			-- ================================================================
			-- 可视模式快捷键
			-- ================================================================
			-- Ctrl+e : 将选中的代码块向下移动
			vim.keymap.set('v', '<c-e>', ':MoveBlock(1)<CR>', opts)

			-- Ctrl+u : 将选中的代码块向上移动
			vim.keymap.set('v', '<c-u>', ':MoveBlock(-1)<CR>', opts)
		end
	},

	-- ========================================================================
	-- 插件 7: substitute.nvim
	-- GitHub: gbprod/substitute.nvim
	-- 功能：快速替换文本（比 Vim 原生替换更方便）
	-- ========================================================================
	--
	-- 工作流程：
	-- 1. 先复制（yank）一些文本
	-- 2. 然后用 s + motion 直接替换目标文本
	--
	-- 示例：
	-- 1. yiw 复制单词 "hello"
	-- 2. 移动到 "world" 上
	-- 3. siw 将 "world" 替换为 "hello"
	--
	{
		"gbprod/substitute.nvim",
		config = function()
			local substitute = require("substitute")
			substitute.setup({
				-- 如果使用 yanky.nvim，可以启用集成
				-- on_substitute = require("yanky.integration").substitute(),

				-- 替换后高亮显示被替换的文本
				highlight_substituted_text = {
					enabled = true,   -- 启用高亮
					timer = 200,      -- 高亮持续时间（毫秒）
				},
			})

			-- ================================================================
			-- 快捷键设置
			-- ================================================================

			-- s + motion : 替换 motion 覆盖的文本
			-- 例如：siw 替换单词，si" 替换引号内内容
			vim.keymap.set("n", "s", substitute.operator, { noremap = true })

			-- sh : 替换从光标到单词末尾（快捷方式）
			vim.keymap.set("n", "sh", function()
				substitute.operator({ motion = "e" })
			end, { noremap = true })

			-- ss : 替换整行
			vim.keymap.set("n", "ss", substitute.line, { noremap = true })

			-- sI : 替换从光标到行尾
			vim.keymap.set("n", "sI", substitute.eol, { noremap = true })

			-- s (可视模式) : 替换选中的文本
			vim.keymap.set("x", "s", substitute.visual, { noremap = true })

			-- s (可视模式，范围替换) : 在选中范围内进行替换
			vim.keymap.set("x", "s", require('substitute.range').visual, { noremap = true })
		end
	},

	-- ========================================================================
	-- 插件 8: nvim-ufo
	-- GitHub: kevinhwang91/nvim-ufo
	-- 功能：现代化的代码折叠
	-- ========================================================================
	--
	-- 特点：
	-- - 比 Vim 原生折叠更美观
	-- - 支持 LSP 和 Treesitter 折叠
	-- - 折叠时可以预览折叠内容
	--
	-- 默认快捷键：
	-- zo : 打开折叠
	-- zc : 关闭折叠
	-- zR : 打开所有折叠
	-- zM : 关闭所有折叠
	--
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },  -- 异步支持库
		config = function()
			require('ufo').setup()
		end
	},

	-- ========================================================================
	-- 插件 9: nvim-autopairs
	-- GitHub: windwp/nvim-autopairs
	-- 功能：自动补全配对符号
	-- ========================================================================
	--
	-- 功能示例：
	-- 输入 ( → 自动变成 ()，光标在中间
	-- 输入 " → 自动变成 ""，光标在中间
	-- 输入 { → 自动变成 {}，光标在中间
	-- 输入 [ → 自动变成 []，光标在中间
	--
	-- 智能功能：
	-- - 如果后面已经有 )，不会重复添加
	-- - 在字符串中输入 ' 不会自动配对
	-- - 删除 ( 时会自动删除对应的 )
	--
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end
	},
}
