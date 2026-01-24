return {
	"kawre/leetcode.nvim",
	lazy = false,
	build = ":TSUpdate html",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		cn = {
			enabled = true, ---@type boolean
			translator = true, ---@type boolean
			translate_problems = true, ---@type boolean
		},
		injector = { ---@type table<lc.lang, lc.inject>
			["python3"] = {
				imports = function(default_imports)
					vim.list_extend(default_imports, { "from .leetcode import *" })
					return default_imports
				end,
				after = { "def test():", "    print('test')" },
			},
			["cpp"] = {
				imports = function()
					-- return a different list to omit default imports
					return { "#include <bits/stdc++.h>", "using namespace std;" }
				end,
				after = "int main() {}",
			},
		},
	},
}
