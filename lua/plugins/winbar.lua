-- ============================================================================
-- Winbar 配置文件
-- 使用 dropbar.nvim 插件在窗口顶部显示面包屑导航栏
-- GitHub: Bekaboo/dropbar.nvim
-- ============================================================================
--
-- 面包屑导航示意图：
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │  󰢱 lua >  plugins >  winbar.lua > 󰊕 setup > 󰅩 keymaps           │
-- └─────────────────────────────────────────────────────────────────────────┘
--    ↑          ↑           ↑            ↑          ↑
--  目录       目录        文件名       函数       当前位置
--
-- 点击任意部分可以展开菜单，快速跳转到对应位置
-- ============================================================================

return {
	-- 插件地址
	"Bekaboo/dropbar.nvim",

	-- ========================================================================
	-- 插件配置函数
	-- ========================================================================
	config = function()
		-- 引入 dropbar API
		local api = require("dropbar.api")

		-- ====================================================================
		-- 全局快捷键设置
		-- ====================================================================

		-- <Leader>;  : 打开面包屑选择器
		-- 可以用键盘在面包屑各部分之间跳转和选择
		vim.keymap.set('n', '<Leader>;', api.pick)

		-- [c : 跳转到当前上下文的开始位置
		-- 例如：跳转到当前函数的开头
		vim.keymap.set('n', '[c', api.goto_context_start)

		-- ]c : 选择下一个上下文
		-- 在面包屑中向右移动选择
		vim.keymap.set('n', ']c', api.select_next_context)

		-- ====================================================================
		-- 辅助函数：确认选择
		-- ====================================================================
		local confirm = function()
			-- 获取当前打开的 dropbar 菜单
			local menu = api.get_current_dropbar_menu()
			if not menu then
				return
			end

			-- 获取光标在菜单窗口中的位置 {行号, 列号}
			local cursor = vim.api.nvim_win_get_cursor(menu.win)

			-- 获取当前行中第一个可点击的组件
			-- cursor[1] : 当前行号
			-- cursor[2] : 当前列号
			local component = menu.entries[cursor[1]]:first_clickable(cursor[2])

			-- 如果找到可点击组件，执行点击操作
			if component then
				menu:click_on(component)
			end
		end

		-- ====================================================================
		-- 辅助函数：关闭当前菜单
		-- ====================================================================
		local quit_curr = function()
			-- 获取当前打开的 dropbar 菜单
			local menu = api.get_current_dropbar_menu()
			if menu then
				-- 关闭菜单
				menu:close()
			end
		end

		-- ====================================================================
		-- dropbar 主配置
		-- ====================================================================
		require("dropbar").setup({
			menu = {
				-- ============================================================
				-- 快速导航
				-- ============================================================
				-- 当启用时，光标移动会自动跳转到最近的可点击组件
				-- true  : 方向键移动时自动对齐到可点击项
				-- false : 自由移动光标
				quick_navigation = true,

				-- ============================================================
				-- 菜单快捷键映射
				-- ============================================================
				-- 格式: ['按键'] = 函数或命令
				---@type table<string, string|function|table<string, string|function>>
				keymaps = {
					-- --------------------------------------------------------
					-- 鼠标左键点击
					-- --------------------------------------------------------
					['<LeftMouse>'] = function()
						-- 获取当前菜单
						local menu = api.get_current_dropbar_menu()
						if not menu then
							return
						end

						-- 获取鼠标位置信息
						local mouse = vim.fn.getmousepos()

						-- 如果点击位置不在当前菜单窗口内
						if mouse.winid ~= menu.win then
							-- 检查是否点击了父级菜单
							local parent_menu = api.get_dropbar_menu(mouse.winid)

							-- 如果点击了父级菜单，关闭当前子菜单
							if parent_menu and parent_menu.sub_menu then
								parent_menu.sub_menu:close()
							end

							-- 如果点击的窗口有效，切换到该窗口
							if vim.api.nvim_win_is_valid(mouse.winid) then
								vim.api.nvim_set_current_win(mouse.winid)
							end
							return
						end

						-- 在鼠标位置执行点击操作
						-- 参数: {行, 列}, nil, 点击次数, 按键('l'=左键)
						menu:click_at({ mouse.line, mouse.column }, nil, 1, 'l')
					end,

					-- --------------------------------------------------------
					-- 确认选择的按键
					-- --------------------------------------------------------
					-- Enter 键：确认选择
					['<CR>'] = confirm,

					-- i 键：确认选择（类似 Vim 的 insert 逻辑）
					['i'] = confirm,

					-- --------------------------------------------------------
					-- 关闭菜单的按键
					-- --------------------------------------------------------
					-- Escape 键：关闭菜单
					['<esc>'] = quit_curr,

					-- q 键：关闭菜单
					['q'] = quit_curr,

					-- n 键：关闭菜单
					['n'] = quit_curr,

					-- --------------------------------------------------------
					-- 鼠标移动（悬停高亮）
					-- --------------------------------------------------------
					['<MouseMove>'] = function()
						-- 获取当前菜单
						local menu = api.get_current_dropbar_menu()
						if not menu then
							return
						end

						-- 获取鼠标位置
						local mouse = vim.fn.getmousepos()

						-- 只在菜单窗口内处理鼠标移动
						if mouse.winid ~= menu.win then
							return
						end

						-- 更新悬停高亮效果
						-- 参数: {行号, 列号（从0开始，所以-1）}
						menu:update_hover_hl({ mouse.line, mouse.column - 1 })
					end,
				},
			},
		})
	end
}
