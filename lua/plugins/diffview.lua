return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = { layout = "diff3_mixed" },
		},
	},
}
