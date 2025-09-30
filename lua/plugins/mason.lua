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
			-- Web
			"html-lsp",
			"css-lsp",
			"json-lsp",
			"yaml-language-server",
      "stylua",

			-- 系统
			"clangd",
			"gopls",
			-- 脚本
			"pyright",
			"bash-language-server",
			-- 文档/配置
			"marksman",
			"lemminx",
			"taplo",
			-- Python lint LSP
			"ruff",
			-- Proto 的回退 LSP（当没有 buf CLI 时用）
			"protols",
		},
	},
}
