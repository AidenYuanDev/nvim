return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-file-browser.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_layout = require("telescope.actions.layout") -- 正确导入布局相关动作
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				prompt_prefix = "🔍 ",
				selection_caret = "➤ ",
				path_display = { "truncate" },

				-- 预览器设置
				previewer = true,

				preview = {
					filesize_limit = 1,
					timeout = 250,
				},

				-- 布局设置
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						width = 0.9,
						height = 0.85,
						preview_width = 0.5,
						preview_cutoff = 60,
					},
					vertical = {
						width = 0.9,
						height = 0.85,
						preview_height = 0.5,
						preview_cutoff = 10,
					},
					prompt_position = "top",
				},

				dynamic_preview_layout = true,
				scroll_strategy = "cycle",

				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-q>"] = actions.send_to_qflist,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,

						-- 修复：使用正确的命名空间
						["<C-l>"] = action_layout.cycle_layout_next, -- 从actions.layout中导入
						["<M-p>"] = action_layout.toggle_preview, -- 从actions.layout中导入
					},
					n = {
						-- 同样修复n模式下的布局切换
						["<C-l>"] = action_layout.cycle_layout_next,
						["<M-p>"] = action_layout.toggle_preview,
					},
				},

				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--trim",
					"--no-ignore",
				},

				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			},

			pickers = {
				live_grep = {
					previewer = true,
					layout_strategy = "flex",
					layout_config = {
						flex = {
							flip_columns = 120,
						},
						vertical = {
							preview_height = 0.4,
							width = 0.9,
							height = 0.9,
							preview_cutoff = 10,
						},
					},
					additional_args = function()
						return { "--hidden", "--no-ignore" }
					end,
				},

				find_files = {
					hidden = true,
					layout_strategy = "flex",
				},

				current_buffer_fuzzy_find = {
					previewer = true,
					layout_strategy = "flex",
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},

				file_browser = {
					hidden = true,
					previewer = true,
					hijack_netrw = true,
					layout_strategy = "flex",
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")

		-- 键位映射保持不变
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fg", function()
			local cwd = vim.fn.getcwd()
			require("telescope.builtin").live_grep({
				cwd = cwd,
				prompt_title = "Search in Project: " .. vim.fn.fnamemodify(cwd, ":t"),
			})
		end, { desc = "Search in project" })

		vim.keymap.set("n", "<leader>fG", function()
			require("telescope.builtin").live_grep({
				layout_strategy = "vertical",
				layout_config = {
					width = 0.9,
					height = 0.9,
					preview_height = 0.5,
					preview_cutoff = 1,
				},
			})
		end, { desc = "Search (vertical layout)" })

		-- 其他键位保持不变
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
		vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "File browser", noremap = true })
		vim.keymap.set("n", "<leader>fw", function()
			builtin.grep_string({ search = vim.fn.expand("<cword>") })
		end, { desc = "Search current word" })
		vim.keymap.set("n", "<leader>fs", function()
			builtin.current_buffer_fuzzy_find()
		end, { desc = "Search in current file" })
	end,
}
