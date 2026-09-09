-- Override NvChad's gitsigns config: inline blame on by default.
-- Toggle it off with <leader>gi.
return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 300,
			ignore_whitespace = false,
		},
	},
}
