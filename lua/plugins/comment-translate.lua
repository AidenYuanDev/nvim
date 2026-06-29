return {
	"noir4y/comment-translate.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = {
		"CommentTranslateHover",
		"CommentTranslateHoverToggle",
		"CommentTranslateReplace",
		"CommentTranslateToggle",
		"CommentTranslateUpdate",
	},
	config = function()
		require("comment-translate").setup({
			target_language = "zh",
			hover = {
				enabled = true,
				delay = 200,
				auto = false,
			},
			keymaps = {
				hover = false,
				hover_manual = false,
				replace = false,
				toggle = false,
			},
		})
	end,
}
