require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>q", "<cmd>q!<CR>", { desc = "quit force" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "save file" })

-- ═══════════════════════════════════════════════════
-- DAP 调试快捷键（优化版）
-- ═══════════════════════════════════════════════════

-- ───────────────────────────────────────────────────
-- 基础执行控制（F 键）
-- ───────────────────────────────────────────────────

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

-- ───────────────────────────────────────────────────
-- 会话控制
-- ───────────────────────────────────────────────────

map("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "continue" })

map("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "terminate" })

map("n", "<leader>dr", function()
	require("dap").restart()
end, { desc = "restart" })

map("n", "<leader>dl", function()
	require("dap").run_last()
end, { desc = "run last" })

map("n", "<leader>dp", function()
	require("dap").pause()
end, { desc = "pause" })

-- ───────────────────────────────────────────────────
-- 断点管理
-- ───────────────────────────────────────────────────

map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "toggle breakpoint" })

map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "conditional breakpoint" })

map("n", "<leader>dL", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "log point" })

map("n", "<leader>dbc", function()
	require("dap").clear_breakpoints()
end, { desc = "clear breakpoints" })

-- 🆕 使用带标题的浮动窗口
map("n", "<leader>dbl", function()
	require("dapui").float_element("breakpoints", {
		width = 80,
		height = 20,
		enter = true,
		position = "center",
		title = "Breakpoints", -- 添加标题
	})
end, { desc = "list breakpoints" })

-- ───────────────────────────────────────────────────
-- 浮动窗口（所有窗口都添加了标题）
-- ───────────────────────────────────────────────────

-- REPL
map("n", "<leader>dR", function()
	require("dapui").float_element("repl", {
		width = 100,
		height = 30,
		enter = true,
		position = "center",
		title = "REPL",
	})
end, { desc = "float repl" })

-- Scopes（变量）
map("n", "<leader>dv", function()
	require("dapui").float_element("scopes", {
		width = 100,
		height = 30,
		enter = true,
		position = "center",
		title = "Variables",
	})
end, { desc = "float scopes" })

-- Stacks（调用栈）
map("n", "<leader>ds", function()
	require("dapui").float_element("stacks", {
		width = 80,
		height = 25,
		enter = true,
		position = "center",
		title = "Call Stack",
	})
end, { desc = "float stacks" })

-- Watches（监视）
map("n", "<leader>dw", function()
	require("dapui").float_element("watches", {
		width = 60,
		height = 15,
		enter = true,
		position = "center",
		title = "Watches",
	})
end, { desc = "float watches" })

-- Console（输出）
map("n", "<leader>do", function()
	require("dapui").float_element("console", {
		width = 100,
		height = 25,
		enter = true,
		position = "center",
		title = "Console",
	})
end, { desc = "float console" })

-- ───────────────────────────────────────────────────
-- 帧和线程
-- ───────────────────────────────────────────────────

-- 帧切换
map("n", "<leader>df", function()
	require("dap").up()
end, { desc = "frame up" })

map("n", "<leader>dF", function()
	require("dap").down()
end, { desc = "frame down" })

-- 线程管理
map("n", "<leader>dT", function()
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

-- ───────────────────────────────────────────────────
-- 变量查看（改进版）
-- ───────────────────────────────────────────────────

-- Hover（使用默认上下文）
map("n", "<leader>dh", function()
	require("dap.ui.widgets").hover()
end, { desc = "hover" })

-- 🆕 Hover（强制使用 REPL 上下文，用于有副作用的表达式）
map("n", "<leader>dH", function()
	require("dap.ui.widgets").hover(nil, { context = "repl" })
end, { desc = "hover (repl context)" })

-- Evaluate（改进：支持指定上下文）
map({ "n", "v" }, "<leader>de", function()
	require("dapui").eval(nil, {
		context = "hover", -- 无副作用
		enter = true,
	})
end, { desc = "evaluate (hover)" })

-- ═══════════════════════════════════════════════════
-- Watches 管理（修复版）
-- ═══════════════════════════════════════════════════

-- 添加光标下的词或选中文本到 watches
map({ "n", "v" }, "<leader>dW", function()
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

-- 手动输入表达式添加
map("n", "<leader>dwa", function()
	local expr = vim.fn.input("Watch expression: ")
	if expr and expr ~= "" then
		require("dapui").elements.watches.add(expr)
		vim.notify("Added to watches: " .. expr, vm.log.levels.INFO)
	end
end, { desc = "add watch (input)" })

-- 列出所有 watches
map("n", "<leader>dwl", function()
	local watches = require("dapui").elements.watches.get()
	if #watches == 0 then
		vim.notify("No watches", vim.log.levels.INFO)
		return
	end

	local items = {}
	for i, watch in ipairs(watches) do
		table.insert(items, string.format("[%d] %s", i, watch.expression))
	end

	vim.notify("Watches:\n" .. table.concat(items, "\n"), vim.log.levels.INFO)
end, { desc = "list watches" })

-- 清除所有 watches
map("n", "<leader>dwc", function()
	local watches = require("dapui").elements.watches.get()
	for i = #watches, 1, -1 do
		require("dapui").elements.watches.remove(i)
	end
	vim.notify("Cleared all watches", vim.log.levels.INFO)
end, { desc = "clear watches" })

-- 编辑特定的 watch（可选）
map("n", "<leader>dwe", function()
	local watches = require("dapui").elements.watches.get()
	if #watches == 0 then
		vim.notify("No watches to edit", vim.log.levels.WARN)
		return
	end

	-- 显示所有 watches 供选择
	local items = {}
	for i, watch in ipairs(watches) do
		table.insert(items, string.format("[%d] %s", i, watch.expression))
	end

	local choice = vim.fn.inputlist(vim.list_extend({ "Select watch to edit:" }, items))
	if choice > 0 and choice <= #watches then
		local new_expr = vim.fn.input("New expression: ", watches[choice].expression)
		if new_expr and new_expr ~= "" then
			require("dapui").elements.watches.edit(choice, new_expr)
			vim.notify("Updated watch " .. choice, vim.log.levels.INFO)
		end
	end
end, { desc = "edit watch" })

-- 删除特定的 watch（可选）
map("n", "<leader>dwr", function()
	local watches = require("dapui").elements.watches.get()
	if #watches == 0 then
		vim.notify("No watches to remove", vim.log.levels.WARN)
		return
	end

	local items = {}
	for i, watch in ipairs(watches) do
		table.insert(items, string.format("[%d] %s", i, watch.expression))
	end

	local choice = vim.fn.inputlist(vim.list_extend({ "Select watch to remove:" }, items))
	if choice > 0 and choice <= #watches then
		require("dapui").elements.watches.remove(choice)
		vim.notify("Removed watch " .. choice, vim.log.levels.INFO)
	end
end, { desc = "remove watch" })

-- 🆕 Evaluate（REPL 上下文，可能有副作用）
map({ "n", "v" }, "<leader>dE", function()
	require("dapui").eval(nil, {
		context = "repl", -- 可能有副作用
		enter = true,
	})
end, { desc = "evaluate (repl)" })

-- 查看内存
map("n", "<leader>dm", function()
	local addr = vim.fn.input("Memory address (hex): 0x")
	if addr and addr ~= "" then
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.expression("*(void**)0x" .. addr))
	end
end, { desc = "view memory" })

-- ───────────────────────────────────────────────────
-- UI 控制（改进版）
-- ───────────────────────────────────────────────────

-- 切换整个 UI
map("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "toggle ui" })

-- 🆕 打开 UI（不会关闭已打开的）
map("n", "<leader>dO", function()
	require("dapui").open()
end, { desc = "open ui" })

-- 🆕 关闭 UI
map("n", "<leader>dC", function()
	require("dapui").close()
end, { desc = "close ui" })

-- 重置 UI 布局
map("n", "<leader>dU", function()
	require("dapui").open({ reset = true })
end, { desc = "reset ui" })

-- 切换左侧面板（layout 1）
map("n", "<leader>d1", function()
	require("dapui").toggle({ layout = 1 })
end, { desc = "toggle left panel" })

-- 切换底部面板（layout 2）
map("n", "<leader>d2", function()
	require("dapui").toggle({ layout = 2 })
end, { desc = "toggle bottom panel" })

-- 🆕 只打开左侧面板
map("n", "<leader>dol", function()
	require("dapui").open({ layout = 1 })
end, { desc = "open left panel" })

-- 🆕 只打开底部面板
map("n", "<leader>dob", function()
	require("dapui").open({ layout = 2 })
end, { desc = "open bottom panel" })

-- 🆕 只关闭左侧面板
map("n", "<leader>dcl", function()
	require("dapui").close({ layout = 1 })
end, { desc = "close left panel" })

-- 🆕 只关闭底部面板
map("n", "<leader>dcb", function()
	require("dapui").close({ layout = 2 })
end, { desc = "close bottom panel" })
