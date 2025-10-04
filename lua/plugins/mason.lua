return {
	"williamboman/mason.nvim",
	config = function(_, opts)
		require("mason").setup(opts)
		local mason_registry = require("mason-registry")
		local ensure_installed = opts.ensure_installed or {}
		-- Ensure all listed tools are installed
		for _, tool in ipairs(ensure_installed) do
			local ok, package = pcall(mason_registry.get_package, tool)
			if ok and not package:is_installed() then
				vim.notify("Installing " .. tool)
				package:install()
			elseif not ok then
				vim.notify("Tool not found: " .. tool, vim.log.levels.WARN)
			end
		end
	end,
	opts = {
		ensure_installed = {
			"html-lsp",
			"css-lsp",
			"json-lsp",
			"yaml-language-server",
			"stylua",
			"clangd",
			"gopls",
			"pyright",
			"bash-language-server",
			"marksman",
			"lemminx",
			"taplo",
			"ruff",
			"protols",
		},
	},
}
