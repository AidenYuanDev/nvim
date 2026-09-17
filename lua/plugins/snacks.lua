return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = function()
		return {
			-- owns `vim.notify`, noice keeps its own notify view disabled
			notifier = {
				enabled = true,
			},
			indent = {
				enabled = true,
				scope = {
					hl = {
						"DiagnosticError", -- red
						"String", -- green
						"Function", -- blue
						"Keyword", -- purple
						"Number", -- orange
					},
				},
			},
		}
	end,
}
