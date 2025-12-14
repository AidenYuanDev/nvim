return {
	-- DAP UI
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				config = function()
					require("nvim-dap-virtual-text").setup({
						all_references = true,
						commented = true,
						highlight_new_as_changed = true,
						virt_text_pos = "eol",
					})
				end,
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dapui.setup({
				controls = {
					element = "repl",
					enabled = true,
					icons = {
						disconnect = "",
						pause = "",
						play = "",
						run_last = "↻",
						step_back = "",
						step_into = "",
						step_out = "",
						step_over = "󰆷",
						terminate = "󰝤",
					},
				},

				element_mappings = {},
				expand_lines = true,

				floating = {
					border = "rounded",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},

				force_buffers = true,

				icons = {
					collapsed = "",
					current_frame = "",
					expanded = "",
				},

				layouts = {
					-- {
					-- 	elements = {
					-- 		{ id = "scopes", size = 0.5 },
					-- 		{ id = "watches", size = 0.3 },
					-- 		{ id = "console", size = 0.2 },
					-- 	},
					-- 	position = "left",
					-- 	size = 30,
					-- },

					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 12,
					},
				},

				mappings = {
					edit = "e",
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					repl = "r",
					toggle = "t",
				},

				render = {
					indent = 1,
					max_value_lines = 100,
				},
			})

			vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "DiagnosticError" })
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { link = "DiagnosticWarn" })
			vim.api.nvim_set_hl(0, "DapStopped", { link = "DiagnosticInfo" })
			vim.api.nvim_set_hl(0, "DapLogPoint", { link = "DiagnosticHint" })
			vim.api.nvim_set_hl(0, "DapBreakpointRejected", { link = "Comment" })

			vim.fn.sign_define("DapBreakpoint", {
				text = " ",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "DapBreakpoint",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟡",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "DapBreakpointCondition",
			})

			vim.fn.sign_define("DapStopped", {
				text = "󰁕 ",
				texthl = "DapStopped",
				linehl = "Visual",
				numhl = "DapStopped",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "⭕",
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "DapBreakpointRejected",
			})

			vim.fn.sign_define("DapLogPoint", {
				text = "💬",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "DapLogPoint",
			})
		end,
	},
}
