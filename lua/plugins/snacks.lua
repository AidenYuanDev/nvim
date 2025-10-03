return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = function()
		return {
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
