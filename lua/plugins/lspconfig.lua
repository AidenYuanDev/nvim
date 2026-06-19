return {
	"neovim/nvim-lspconfig",
	config = function()
		local nvlsp = require("nvchad.configs.lspconfig")
		nvlsp.defaults()

		vim.lsp.enable({ "gopls", "yamlls", "pyright", "jsonls", "clangd", "neocmake", "vtsls", "cssls", "html" })

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						test = true,
						tidy = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						functionTypeParameters = true,
						parameterNames = true,
					},
					analyses = {
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-**/node_modules", "-**/dist" },
				},
			},
		})

		local ok_js, schemastore = pcall(require, "schemastore")
		vim.lsp.config("jsonls", {
			settings = {
				json = {
					validate = { enable = true },
					format = { enable = false },
					schemas = ok_js and schemastore.json.schemas() or nil,
				},
			},
		})

		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					format = { enable = false },
					validate = true,
					hover = true,
					completion = true,
					keyOrdering = false,
					schemaStore = { enable = true, url = "" },
					schemas = ok_js and schemastore.yaml.schemas() or nil,
				},
			},
		})

		vim.lsp.config("pyright", {
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
						typeCheckingMode = "off",
					},
				},
			},
		})

		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--offset-encoding=utf-8",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--all-scopes-completion",
				"--pch-storage=memory",
			},
			root_markers = { "compile_commands.json", ".clangd", ".git" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
		})
		vim.lsp.config("neocmake", {
			cmd = { "neocmakelsp", "--stdio" },
			root_markers = { "CMakeLists.txt", ".git" },
		})

		vim.lsp.config("vtsls", {
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
				javascript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
			},
		})

		vim.lsp.config("cssls", {
			settings = {
				css = { validate = true, lint = { unknownAtRules = "ignore" } },
				scss = { validate = true, lint = { unknownAtRules = "ignore" } },
				less = { validate = true },
			},
		})

		vim.lsp.config("html", {
			filetypes = { "html", "htmldjango" },
			init_options = {
				provideFormatter = false, -- 交给 conform/prettier
			},
		})
	end,
}
