return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			-- 获取 NvChad 的主题颜色
			local colors = require("base46").get_theme_tb("base_30")

			vim.api.nvim_set_hl(0, "RainbowRed", { fg = colors.red })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = colors.yellow })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = colors.blue })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = colors.orange })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = colors.green })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = colors.purple })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = colors.cyan })
		end)

		vim.g.rainbow_delimiters = { highlight = highlight }
		require("ibl").setup({ scope = { highlight = highlight } })
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
