return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			update_focused_file = {
				enable = true,
				update_root = true,
			},
			sync_root_with_cwd = true,
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
				highlight_git = true,
				highlight_opened_files = "none", -- 禁用文件高亮以解决问题
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
					resize_window = true,
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
			-- 移除了有问题的on_attach事件处理部分
		})

		-- 智能切换函数
		local function smart_nvimtree_toggle()
			local api = require("nvim-tree.api")
			local current_buf = vim.api.nvim_get_current_buf()
			local current_file = vim.api.nvim_buf_get_name(current_buf)

			if api.tree.is_visible() then
				api.tree.close()
			else
				if current_file and current_file ~= "" then
					api.tree.open()
					vim.defer_fn(function()
						api.tree.find_file(current_file)
					end, 50)
				else
					api.tree.open()
				end
			end
		end

		-- 设置键位映射
		local keymap = vim.keymap
		keymap.set("n", "<leader>ee", smart_nvimtree_toggle, { desc = "Toggle file explorer and focus current file" })
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in tree" })
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

		-- 替代事件系统的自动命令
		local group = vim.api.nvim_create_augroup("NvimTreeRefresh", { clear = true })

		-- 在缓冲区切换时刷新NvimTree
		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = function()
				-- 避免在NvimTree缓冲区中执行
				if vim.bo.filetype ~= "NvimTree" then
					vim.defer_fn(function()
						local api = require("nvim-tree.api")
						-- 安全地检查api.tree是否存在
						if api and api.tree and type(api.tree.is_visible) == "function" and api.tree.is_visible() then
							-- 安全地检查reload函数
							if type(api.tree.reload) == "function" then
								api.tree.reload()
							end
						end
					end, 100)
				end
			end,
		})

		-- 简单的清除高亮方法
		vim.api.nvim_create_autocmd("WinLeave", {
			pattern = "*",
			callback = function()
				if vim.bo.filetype == "NvimTree" then
					vim.cmd("redraw")
				end
			end,
		})
	end,
}
