-- dap-ui.lua
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
				opts = {},
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
				-- 控制面板配置（显示在 REPL 窗口顶部）
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

				-- 浮动窗口配置
				floating = {
					border = "rounded",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},

				force_buffers = true,

				-- 图标
				icons = {
					collapsed = "",
					current_frame = "",
					expanded = "",
				},

				-- 🎯 左右分屏布局
				layouts = {
					-- 左侧：只显示变量
					{
						elements = {
							{ id = "scopes", size = 0.5 },
							{ id = "watches", size = 0.3 },
							{ id = "console", size = 0.2 },
						},
						position = "left",
						size = 30,
					},

					-- 底部：只显示控制台输出
					{
						elements = {
							{ id = "repl", size = 1 },
						},
						position = "bottom",
						size = 6,
					},
				},

				-- 按键映射
				mappings = {
					edit = "e",
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					repl = "r",
					toggle = "t",
				},

				-- 渲染设置
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

			-- 设置断点图标
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
