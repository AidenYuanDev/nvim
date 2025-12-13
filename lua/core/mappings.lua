require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

-- ═══════════════════════════════════════════════════
-- Basic
-- ═══════════════════════════════════════════════════
map("n", ";", ":", { desc = "CMD enter command mode" })

map("v", "<Tab>", ">gv", { desc = "Indent right" })
map("v", "<S-Tab>", "<gv", { desc = "Indent left" })
map("n", "<leader>ww", "<cmd>w<CR>", { desc = "File Save" })
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "File Quit all" })

-- ═══════════════════════════════════════════════════
-- DAP
-- ═══════════════════════════════════════════════════
map("n", "<F5>", function()
	require("dap").continue()
end, { desc = "Debug continue" })

map("n", "<F6>", function()
	require("dap").pause()
end, { desc = "Debug pause" })

map("n", "<F9>", function()
	require("dap").run_to_cursor()
end, { desc = "Debug run to cursor" })

map("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "Debug step over" })

map("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "Debug step into" })

map("n", "<F12>", function()
	require("dap").step_out()
end, { desc = "Debug step out" })

map("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Debug terminate" })

map("n", "<leader>dp", function()
	require("dap").pause()
end, { desc = "Debug pause" })

map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debug toggle breakpoint" })

map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug conditional breakpoint" })

map("n", "<leader>dib", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Debug log point" })

map("n", "<leader>dcb", function()
	require("dap").clear_breakpoints()
end, { desc = "Debug clear breakpoints" })

map("n", "<leader>dlb", function()
	require("dapui").float_element("breakpoints", {
		width = 80,
		height = 20,
		enter = true,
		position = "center",
		title = "Breakpoints",
	})
end, { desc = "Debug list breakpoints" })

map("n", "<leader>dlr", function()
	require("dapui").float_element("repl", {
		width = 100,
		height = 30,
		enter = true,
		position = "center",
		title = "REPL",
	})
end, { desc = "Debug float repl" })

map("n", "<leader>dlv", function()
	require("dapui").float_element("scopes", {
		width = 100,
		height = 30,
		enter = true,
		position = "center",
		title = "Variables",
	})
end, { desc = "Debug float scopes" })

map("n", "<leader>dls", function()
	require("dapui").float_element("stacks", {
		width = 80,
		height = 25,
		enter = true,
		position = "center",
		title = "Call Stack",
	})
end, { desc = "Debug float stacks" })

map("n", "<leader>dlw", function()
	require("dapui").float_element("watches", {
		width = 60,
		height = 15,
		enter = true,
		position = "center",
		title = "Watches",
	})
end, { desc = "Debug float watches" })

map("n", "<leader>dlo", function()
	require("dapui").float_element("console", {
		width = 100,
		height = 25,
		enter = true,
		position = "center",
		title = "Console",
	})
end, { desc = "Debug float console" })

map("n", "<leader>df", function()
	require("dap").up()
end, { desc = "Debug frame up" })

map("n", "<leader>dF", function()
	require("dap").down()
end, { desc = "Debug frame down" })

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
end, { desc = "Debug switch thread" })

map({ "n", "v" }, "<leader>de", function()
	require("dapui").eval(nil, {
		context = "hover",
		enter = true,
	})
end, { desc = "Debug evaluate (hover)" })

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
end, { desc = "Debug add to watches" })

map("n", "<leader>daw", function()
	local expr = vim.fn.input("Watch expression: ")
	if expr and expr ~= "" then
		require("dapui").elements.watches.add(expr)
		vim.notify("Added to watches: " .. expr, vim.log.levels.INFO)
	end
end, { desc = "Debug add watch (input)" })

map("n", "<leader>dcw", function()
	local watches = require("dapui").elements.watches.get()
	for i = #watches, 1, -1 do
		require("dapui").elements.watches.remove(i)
	end
	vim.notify("Cleared all watches", vim.log.levels.INFO)
end, { desc = "Debug clear watches" })

map("n", "<leader>dm", function()
	local addr = vim.fn.input("Memory address (hex): 0x")
	if addr and addr ~= "" then
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.expression("*(void**)0x" .. addr))
	end
end, { desc = "Debug view memory" })

map("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Debug toggle ui" })

map("n", "<leader>dU", function()
	require("dapui").open({ reset = true })
end, { desc = "Debug reset ui" })

-- ═══════════════════════════════════════════════════
-- Flash
-- ═══════════════════════════════════════════════════
map({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash jump" })

map({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash treesitter" })

map("o", "r", function()
	require("flash").remote()
end, { desc = "Flash remote" })

map({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Flash treesitter search" })

map("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Flash toggle search" })

-- ═══════════════════════════════════════════════════
-- Noice
-- ═══════════════════════════════════════════════════
map("c", "<S-Enter>", function()
	require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Noice redirect cmdline" })

map("n", "<leader>snl", function()
	require("noice").cmd("last")
end, { desc = "Noice last message" })

map("n", "<leader>snh", function()
	require("noice").cmd("history")
end, { desc = "Noice history" })

map("n", "<leader>sna", function()
	require("noice").cmd("all")
end, { desc = "Noice all" })

map("n", "<leader>snd", function()
	require("noice").cmd("dismiss")
end, { desc = "Noice dismiss all" })

map("n", "<leader>snt", function()
	require("noice").cmd("pick")
end, { desc = "Noice picker" })

map({ "i", "n", "s" }, "<c-f>", function()
	if not require("noice.lsp").scroll(4) then
		return "<c-f>"
	end
end, { silent = true, expr = true, desc = "Noice scroll forward" })

map({ "i", "n", "s" }, "<c-b>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<c-b>"
	end
end, { silent = true, expr = true, desc = "Noice scroll backward" })

-- ═══════════════════════════════════════════════════
-- Venv Select
-- ═══════════════════════════════════════════════════
-- keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
