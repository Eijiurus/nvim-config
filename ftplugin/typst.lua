-- ============================================================================
-- Typst 文件类型配置
-- 文件位置：~/.config/nvim/ftplugin/typst.lua
-- 当打开 .typ 文件时自动加载此配置
-- ============================================================================

-- ============================================================================
-- 基础选项
-- ============================================================================
vim.opt_local.wrap = false           -- 禁用自动换行
vim.opt_local.conceallevel = 2       -- 启用文本隐藏
vim.opt_local.shiftwidth = 2         -- 缩进宽度
vim.opt_local.tabstop = 2            -- Tab 宽度
vim.opt_local.expandtab = true       -- 使用空格代替 Tab

-- ============================================================================
-- 辅助函数：获取 Git 仓库根目录
-- ============================================================================
-- Typst 编译时需要指定 --root 参数
-- 如果文件访问外部数据（如图片），数据必须在编译根目录内
-- 这是 Typst 的安全特性，防止读取敏感文件（如 SSH 私钥）
--
-- @return string: Git 根目录路径，如果不在 Git 仓库中则返回当前文件目录
local function get_git_root()
	-- 查找 .git 目录
	local git_dir = vim.fn.finddir('.git', vim.fn.expand('%:p:h') .. ';')
	if git_dir ~= '' then
		-- 返回 .git 的父目录
		return vim.fn.fnamemodify(git_dir, ':h')
	else
		-- 如果不在 Git 仓库中，返回当前文件所在目录
		return vim.fn.expand('%:p:h')
	end
end

-- ============================================================================
-- 功能 1: Typst Watch（自动编译）
-- ============================================================================
-- 工作原理：
-- 1. 在右侧打开一个小的垂直分割窗口
-- 2. 在该窗口中运行 `typst watch` 命令
-- 3. 每次保存文件时，Typst 会自动重新编译
-- 4. 编译错误会显示在该窗口中
--
-- 快捷键：<Leader>fc (file compile)
--
local function typst_watch()
	-- 获取当前文件路径
	local file = vim.fn.expand('%:p')
	-- 获取编译根目录
	local root = get_git_root()

	-- 创建垂直分割窗口
	vim.cmd('vsplit')
	-- 调整窗口宽度为 30 列（用于显示编译输出）
	vim.cmd('vertical resize 30')

	-- 在终端中运行 typst watch
	-- --root: 指定编译根目录
	vim.cmd('terminal typst watch --root ' .. root .. ' ' .. file)

	-- 返回到原来的窗口（左侧编辑窗口）
	vim.cmd('wincmd h')
end

vim.keymap.set('n', '<leader>fc', typst_watch, {
	buffer = true,
	desc = 'Typst: Start watching (compile on save)'
})

-- ============================================================================
-- 功能 2: 单次编译
-- ============================================================================
-- 如果不想持续监视文件，可以使用此命令进行单次编译
--
-- 快捷键：<Leader>fb (file build)
--
local function typst_compile()
	local file = vim.fn.expand('%:p')
	local root = get_git_root()

	-- 同步编译（会阻塞编辑器直到完成）
	local result = vim.fn.system('typst compile --root ' .. root .. ' ' .. file)

	if vim.v.shell_error == 0 then
		vim.notify('Typst: Compiled successfully', vim.log.levels.INFO)
	else
		vim.notify('Typst: Compilation failed\n' .. result, vim.log.levels.ERROR)
	end
end

vim.keymap.set('n', '<leader>fb', typst_compile, {
	buffer = true,
	desc = 'Typst: Compile once'
})

-- ============================================================================
-- 功能 3: 打开 PDF 预览（使用 Zathura）
-- ============================================================================
-- Zathura 是一个轻量级的 PDF 阅读器
-- 安装：sudo apt install zathura
--
-- 工作原理：
-- 1. 获取当前 .typ 文件对应的 .pdf 文件路径
-- 2. 使用 Zathura 打开该 PDF
-- 3. --fork 参数使 Zathura 在后台运行，不阻塞 Neovim
--
-- 快捷键：<Leader>fr (file read/view)
--
local function open_pdf()
	-- 将 .typ 扩展名替换为 .pdf
	local pdf_file = vim.fn.expand('%:p:r') .. '.pdf'

	-- 检查 PDF 文件是否存在
	if vim.fn.filereadable(pdf_file) == 0 then
		vim.notify('Typst: PDF not found. Compile first with <Leader>fc', vim.log.levels.WARN)
		return
	end

	-- 使用 Zathura 打开 PDF（后台运行）
	vim.fn.jobstart({ 'zathura', '--fork', pdf_file }, { detach = true })
end

vim.keymap.set('n', '<leader>fr', open_pdf, {
	buffer = true,
	desc = 'Typst: Open PDF in Zathura'
})

-- ============================================================================
-- 功能 4: Tinymist LSP 预览（浏览器实时预览）
-- ============================================================================
-- Tinymist 是 Typst 的语言服务器，提供：
-- - 自动补全
-- - 错误检测
-- - 代码格式化
-- - 实时浏览器预览（每次编辑时自动刷新）
--
-- 安装 Tinymist：
--   方法 1: 通过 Mason（推荐）
--     :MasonInstall tinymist
--   方法 2: 通过 Cargo
--     cargo install tinymist
--
-- 注意：Tinymist 预览会消耗更多电量，因为它在每次按键时重新编译
-- 如果你在意电池续航，建议使用上面的 typst watch + Zathura 方案
--
-- 快捷键：<Leader>fp (file preview)
--
local function tinymist_preview()
	-- 获取 Tinymist LSP 客户端
	local clients = vim.lsp.get_clients({ name = 'tinymist' })

	if #clients == 0 then
		vim.notify('Typst: Tinymist LSP not running', vim.log.levels.WARN)
		return
	end

	-- 执行 Tinymist 的预览命令
	-- 这会在浏览器中打开实时预览窗口
	clients[1]:exec_cmd({
		command = 'tinymist.startDefaultPreview',
		title = 'Preview'
	})
end

vim.keymap.set('n', '<leader>fp', tinymist_preview, {
	buffer = true,
	desc = 'Typst: Start Tinymist preview (browser)'
})

-- ============================================================================
-- 功能 5: 导出为 PDF（通过 Tinymist）
-- ============================================================================
-- 快捷键：<Leader>fe (file export)
--
local function tinymist_export()
	local clients = vim.lsp.get_clients({ name = 'tinymist' })

	if #clients == 0 then
		vim.notify('Typst: Tinymist LSP not running', vim.log.levels.WARN)
		return
	end

	clients[1]:exec_cmd({
		command = 'tinymist.exportPdf',
		title = 'Export PDF'
	})

	vim.notify('Typst: Exported to PDF', vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>fe', tinymist_export, {
	buffer = true,
	desc = 'Typst: Export PDF (via Tinymist)'
})

-- ============================================================================
-- 功能 6: 格式化代码
-- ============================================================================
-- 使用 Typst 或 Tinymist 的格式化功能
--
-- 快捷键：<Leader>lf (与其他 LSP 保持一致)
--
vim.keymap.set('n', '<leader>lf', function()
	vim.lsp.buf.format({ async = true })
end, {
	buffer = true,
	desc = 'Typst: Format buffer'
})

-- ============================================================================
-- 功能 7: 智能链接打开
-- ============================================================================
-- 在 Typst 中打开光标下的链接或引用
--
-- 快捷键：gx
--
vim.keymap.set('n', 'gx', function()
	local line = vim.fn.getline('.')
	local col = vim.fn.col('.')

	-- 尝试匹配 Typst 链接语法：#link("url")
	-- 或普通 URL
	local patterns = {
		'#link%("([^"]+)"',     -- #link("url")
		'https?://[%w%.%-_/%%%?=&#]+',  -- http(s)://...
	}

	for _, pattern in ipairs(patterns) do
		local start_pos = 1
		while true do
			local s, e, url = line:find(pattern, start_pos)
			if not s then break end

			-- 检查光标是否在匹配范围内
			if col >= s and col <= e then
				local open_url = url or line:sub(s, e)
				vim.ui.open(open_url)
				return
			end

			start_pos = e + 1
		end
	end

	-- 回退到默认行为
	vim.cmd('normal! gx')
end, {
	buffer = true,
	desc = 'Typst: Smart URL opener'
})

-- ============================================================================
-- 功能 8: 快速插入模板
-- ============================================================================
-- 在空文件中快速插入常用模板
--
-- 快捷键：<Leader>ft (file template)
--
local function insert_template()
	-- 检查文件是否为空
	if vim.fn.line('$') > 1 or vim.fn.getline(1) ~= '' then
		vim.notify('Typst: Buffer not empty', vim.log.levels.WARN)
		return
	end

	-- 基础笔记模板
	local template = [[
// ============================================================================
// 文档设置
// ============================================================================
#set page(paper: "a4", margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "zh")
#set heading(numbering: "1.1")
#set par(justify: true, leading: 0.8em)

// ============================================================================
// 数学快捷方式
// ============================================================================
#let Rn = $RR^n$
#let R2 = $RR^2$
#let R3 = $RR^3$

// ============================================================================
// 文档内容
// ============================================================================

= 标题

== 第一章

这是正文内容。

=== 小节

行内数学：$1 + 1 = 2$

显示数学：
$
integral_0^1 x^2 dif x = 1/3
$

]]

	-- 插入模板
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, '\n'))
	vim.notify('Typst: Template inserted', vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>ft', insert_template, {
	buffer = true,
	desc = 'Typst: Insert template'
})

-- ============================================================================
-- 自动配置：启用 Treesitter 高亮（如果可用）
-- ============================================================================
pcall(vim.treesitter.start)

-- ============================================================================
-- 快捷键总览
-- ============================================================================
-- <Leader>fc : 启动 typst watch（持续编译）
-- <Leader>fb : 单次编译
-- <Leader>fr : 用 Zathura 打开 PDF
-- <Leader>fp : 启动 Tinymist 浏览器预览
-- <Leader>fe : 导出 PDF（通过 Tinymist）
-- <Leader>lf : 格式化代码
-- <Leader>ft : 插入模板
-- gx         : 智能打开链接
-- ============================================================================
