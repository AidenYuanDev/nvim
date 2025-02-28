return {
	"akinsho/toggleterm.nvim",
	version = "*", -- Use the latest version
	config = function()
		require("toggleterm").setup({
			-- Terminal size configuration
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
				return 20
			end,

			-- Basic settings
			hide_numbers = true, -- Hide the number column in terminal buffers
			shade_filetypes = {},
			autochdir = false, -- When neovim changes directory, terminal won't follow

			-- Highlight settings
			-- highlights = {
			-- 	Normal = {
			-- 		guibg = "#1a1b26", -- Terminal background color
			-- 	},
			-- 	NormalFloat = {
			-- 		link = "Normal",
			-- 	},
			-- 	FloatBorder = {
			-- 		guifg = "#7aa2f7", -- Border color
			-- 		guibg = "#1a1b26", -- Border background color
			-- 	},
			-- },

			-- Terminal shading settings
			shade_terminals = false,
			-- shading_factor = -30, -- Percentage to lighten terminal background

			-- Terminal behavior
			start_in_insert = true,
			insert_mappings = true, -- Open mapping works in insert mode
			terminal_mappings = true, -- Open mapping works in opened terminals
			persist_size = true,
			persist_mode = true, -- Remember previous terminal mode
			direction = "float", -- Default direction: vertical, horizontal, tab, float
			close_on_exit = true, -- Close terminal window when process exits

			-- Terminal scroll behavior
			auto_scroll = true, -- Automatically scroll to bottom on terminal output

			-- Floating terminal options
			float_opts = {
				border = "curved", -- Border style: single, double, shadow, curved
				-- width = math.floor(vim.o.columns * 0.85),
				-- height = math.floor(vim.o.lines * 0.8),
				-- winblend = 10, -- Transparency (0-100, 0 is opaque)
				-- title_pos = "center",
			},

			-- Window bar configuration
			winbar = {
				enabled = false,
				name_formatter = function(term)
					return term.name or "Terminal"
				end,
			},

			-- Responsive layout
			responsiveness = {
				horizontal_breakpoint = 135,
			},
		})

		------------------------
		-- Key mappings
		------------------------

		-- Global shortcut: Ctrl+\ to toggle terminal
		vim.keymap.set({ "n", "t" }, "<C-\\>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

		-- Different terminal layout shortcuts
		vim.keymap.set("n", "<leader>th", "<Cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
		vim.keymap.set("n", "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical terminal" })
		vim.keymap.set("n", "<leader>tf", "<Cmd>ToggleTerm direction=float<CR>", { desc = "Floating terminal" })
		vim.keymap.set("n", "<leader>tt", "<Cmd>ToggleTerm direction=tab<CR>", { desc = "Tab terminal" })

		-- Terminal mode keymaps
		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			-- ESC to enter normal mode
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			-- Alternative jk to enter normal mode
			vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
			-- Navigate between windows with Ctrl+h/j/k/l
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		end

		-- Apply mappings to each terminal buffer
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end,
}
