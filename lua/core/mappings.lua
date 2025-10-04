require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ═══════════════════════════════════════════════════
-- DAP
-- ═══════════════════════════════════════════════════
map("n", "<F5>", function()
	require("dap").continue()
end, { desc = "debug: continue" })

map("n", "<F6>", function()
	require("dap").pause()
end, { desc = "debug: pause" })

map("n", "<F9>", function()
	require("dap").run_to_cursor()
end, { desc = "debug: run to cursor" })

map("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "debug: step over" })

map("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "debug: step into" })

map("n", "<F12>", function()
	require("dap").step_out()
end, { desc = "debug: step out" })

map("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "terminate" })

map("n", "<leader>dp", function()
	require("dap").pause()
end, { desc = "pause" })

map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "toggle breakpoint" })

map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "conditional breakpoint" })

map("n", "<leader>dib", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "log point" })

map("n", "<leader>dcb", function()
	require("dap").clear_breakpoints()
end, { desc = "clear breakpoints" })

map("n", "<leader>dlb", function()
	require("dapui").float_element("breakpoints", {
		width = 80,
		height = 20,
		enter = true,
		position = "center",
		title = "Breakpoints",
	})
end, { desc = "list breakpoints" })

map("n", "<leader>dlr", function()
	require("dapui").float_element("repl", {
		width = 100,
		height = 30,
		enter = true,
		position = "center",
		title = "REPL",
	})
end, { desc = "float repl" })

map("n", "<leader>dlv", function()
	require("dapui").float_element("scopes", {
		width = 100,
		height = 30,
		enter = true,
		position = "center",
		title = "Variables",
	})
end, { desc = "float scopes" })

map("n", "<leader>dls", function()
	require("dapui").float_element("stacks", {
		width = 80,
		height = 25,
		enter = true,
		position = "center",
		title = "Call Stack",
	})
end, { desc = "float stacks" })

map("n", "<leader>dlw", function()
	require("dapui").float_element("watches", {
		width = 60,
		height = 15,
		enter = true,
		position = "center",
		title = "Watches",
	})
end, { desc = "float watches" })

map("n", "<leader>dlo", function()
	require("dapui").float_element("console", {
		width = 100,
		height = 25,
		enter = true,
		position = "center",
		title = "Console",
	})
end, { desc = "float console" })

map("n", "<leader>df", function()
	require("dap").up()
end, { desc = "frame up" })

map("n", "<leader>dF", function()
	require("dap").down()
end, { desc = "frame down" })

map("n", "<leader>dlt", function()
	local dap = require("dap")
	local session = dap.session()

	if not session then
		vim.notify("No active debug session", vim.log.levels.WARN)
		return
	end

	session:request("threads", nil, function(err, response)
		if err then
			vim.notify("Error fetching threads: " .. err.message, vim.log.levels.ERROR)
			return
		end

		local threads = {}
		for _, thread in ipairs(response.threads) do
			table.insert(threads, {
				id = thread.id,
				name = thread.name or "Thread " .. thread.id,
			})
		end

		vim.ui.select(threads, {
			prompt = "Select thread:",
			format_item = function(thread)
				return thread.name
			end,
		}, function(choice)
			if choice then
				session:request("stackTrace", {
					threadId = choice.id,
				}, function()
					vim.notify("Switched to " .. choice.name, vim.log.levels.INFO)
				end)
			end
		end)
	end)
end, { desc = "switch thread" })

map({ "n", "v" }, "<leader>de", function()
	require("dapui").eval(nil, {
		context = "hover",
		enter = true,
	})
end, { desc = "evaluate (hover)" })

map({ "n", "v" }, "<leader>dw", function()
	local expr
	if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
		vim.cmd('normal! "vy')
		expr = vim.fn.getreg("v")
	else
		expr = vim.fn.expand("<cword>")
	end

	if expr and expr ~= "" then
		require("dapui").elements.watches.add(expr)
		vim.notify("Added to watches: " .. expr, vim.log.levels.INFO)
	else
		local input = vim.fn.input("Watch expression: ")
		if input and input ~= "" then
			require("dapui").elements.watches.add(input)
			vim.notify("Added to watches: " .. input, vim.log.levels.INFO)
		end
	end
end, { desc = "add to watches" })

map("n", "<leader>daw", function()
	local expr = vim.fn.input("Watch expression: ")
	if expr and expr ~= "" then
		require("dapui").elements.watches.add(expr)
		vim.notify("Added to watches: " .. expr, vim.log.levels.INFO)
	end
end, { desc = "add watch (input)" })

map("n", "<leader>dcw", function()
	local watches = require("dapui").elements.watches.get()
	for i = #watches, 1, -1 do
		require("dapui").elements.watches.remove(i)
	end
	vim.notify("Cleared all watches", vim.log.levels.INFO)
end, { desc = "clear watches" })

map("n", "<leader>dm", function()
	local addr = vim.fn.input("Memory address (hex): 0x")
	if addr and addr ~= "" then
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.expression("*(void**)0x" .. addr))
	end
end, { desc = "view memory" })

map("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "toggle ui" })

map("n", "<leader>dU", function()
	require("dapui").open({ reset = true })
end, { desc = "reset ui" })
