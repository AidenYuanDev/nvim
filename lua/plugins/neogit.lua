return {
	"NeogitOrg/neogit",
	cmd = "Neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"folke/snacks.nvim",
	},
	opts = {
		graph_style = "unicode",
		integrations = {
			diffview = true,
			snacks = true,
		},
	},
}
