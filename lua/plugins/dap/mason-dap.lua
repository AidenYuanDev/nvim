return {
	"jay-babu/mason-nvim-dap.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	event = "VeryLazy",
	config = function()
		require("mason-nvim-dap").setup({
			ensure_installed = { "codelldb", "python" },
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,

				-- C/C++ Customize
				codelldb = function(config)
					local dap = require("dap")

					dap.adapters.codelldb = {
						type = "server",
						port = "${port}",
						executable = {
							command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
							args = { "--port", "${port}" },
						},
					}

					dap.configurations.cpp = {
						{
							name = "Launch (select file)",
							type = "codelldb",
							request = "launch",
							program = function()
								return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
							end,
							cwd = "${workspaceFolder}",
						},
						{
							name = "Launch with args",
							type = "codelldb",
							request = "launch",
							program = function()
								return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
							end,
							args = function()
								local input = vim.fn.input("Args: ")
								return vim.split(input, " ", { trimempty = true })
							end,
							cwd = "${workspaceFolder}",
						},
						{
							name = "Attach to process",
							type = "codelldb",
							request = "attach",
							pid = require("dap.utils").pick_process,
						},
					}
					dap.configurations.c = dap.configurations.cpp
				end,
			},
		})
	end,
}
