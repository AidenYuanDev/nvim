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
		-- WORKAROUND: the google backend hardcodes `client=gtx`, which Google now
		-- answers with 429 for every request. `client=dict-chrome-ex` is served
		-- normally and returns the very same JSON shape, so rewrite the url the
		-- backend builds instead of patching the plugin.
		local curl_config = require("comment-translate.translate.curl_config")
		local option = curl_config.option
		curl_config.option = function(name, value)
			if name == "url" and type(value) == "string" then
				value = value:gsub("client=gtx", "client=dict-chrome-ex")
			end
			return option(name, value)
		end

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
