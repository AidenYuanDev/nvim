-- dap-ui.lua
return {
	-- DAP UI
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		keys = {
			-- ==================== UI 控制 ====================
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval Expression",
				mode = { "n", "v" },
			},

			-- ==================== 断点管理 ====================
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Conditional Breakpoint",
			},
			{
				"<leader>dL",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "Log Point",
			},
			{
				"<leader>dx",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "Clear All Breakpoints",
			},

			-- ==================== 运行控制 ====================
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Start/Continue",
			},
			{
				"<leader>da",
				function()
					local dap = require("dap")
					dap.continue({
						before = function(config)
							local args = vim.fn.input("Arguments: ")
							if args ~= "" then
								config.args = vim.split(args, " +")
							end
							return config
						end,
					})
				end,
				desc = "Run with Args",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},

			-- ==================== 单步调试 ====================
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down Stack",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up Stack",
			},

			-- ==================== REPL & Session ====================
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Show Session",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets (Hover)",
			},
			{
				"<leader>df",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.frames)
				end,
				desc = "Show Frames",
			},
			{
				"<leader>dS",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes)
				end,
				desc = "Show Scopes",
			},
		},
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup(opts)

			-- 自动打开/关闭 UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			-- 设置断点图标
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟡",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "⭕",
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "➤",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			})

			vim.fn.sign_define("DapLogPoint", {
				text = "📝",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})
		end,
	},

	-- Virtual text
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup({
				highlight_new_as_changed = true,
				commented = true,
				all_references = true,
			})
		end,
	},

	-- mason for dap
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		event = "VeryLazy", -- ✅ 启动后立即加载
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
}
