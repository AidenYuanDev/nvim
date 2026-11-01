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

		-- Pascal: gdb understands FPC's DWARF and Pascal types better than lldb
		local dap = require("dap")
		-- gdb's DAP has no runInTerminal, so the debuggee's stdin would be /dev/null.
		-- Open a terminal in the dap-ui console ourselves and hand its pty to gdb.
		local console_job, console_buf
		-- the console buffer can only host a new terminal once the old job has exited
		-- and the buffer is unmodified (nvim-dap won't reset it for other adapters)
		local function close_console_tty()
			if console_job then
				vim.fn.jobstop(console_job)
				vim.fn.jobwait({ console_job }, 1000)
				console_job = nil
			end
			if console_buf and vim.api.nvim_buf_is_valid(console_buf) then
				vim.bo[console_buf].modified = false
			end
		end

		local function open_console_tty()
			local get_buf = dap.defaults.fallback.terminal_win_cmd
			if type(get_buf) ~= "function" then
				return nil
			end
			close_console_tty()
			console_buf = get_buf()
			vim.bo[console_buf].modified = false
			vim.api.nvim_buf_call(console_buf, function()
				console_job = vim.fn.jobstart({ "sleep", "infinity" }, { term = true })
			end)
			return vim.api.nvim_get_chan_info(console_job).pty
		end

		-- free the console for other adapters (codelldb's runInTerminal) once the session ends
		dap.listeners.after.event_exited["pascal_console"] = close_console_tty
		dap.listeners.after.event_terminated["pascal_console"] = close_console_tty
		dap.listeners.after.disconnect["pascal_console"] = close_console_tty

		-- pass the program to gdb so it's loaded before setBreakpoints arrives
		dap.adapters.gdb = function(callback, config)
			local args = {
				"-q",
				"--interpreter=dap",
				"--eval-command",
				"set print pretty on",
				-- show FPC strings as one value instead of a char array (for dap-ui/virtual-text)
				"--eval-command",
				"source " .. vim.fn.stdpath("config") .. "/gdb/fpc_strings.py",
			}
			local tty = config.request == "launch" and open_console_tty()
			if tty then
				vim.list_extend(args, { "--eval-command", "set inferior-tty " .. tty })
			end
			table.insert(args, config.program)
			callback({ type = "executable", command = "gdb", args = args })
		end

		dap.configurations.pascal = {
			{
				name = "Launch (select file)",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
			{
				name = "Launch with args",
				type = "gdb",
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
				type = "gdb",
				request = "attach",
				pid = require("dap.utils").pick_process,
			},
		}
	end,
}
