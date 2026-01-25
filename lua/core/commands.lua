-- Countdown timer
local countdown_state = {
	timer = nil,
	end_time = nil,
}
vim.api.nvim_create_user_command("Countdown", function(opts)
	local minutes = tonumber(opts.args)
	if not minutes then
		if countdown_state.end_time then
			local remaining = countdown_state.end_time - vim.loop.now()
			if remaining > 0 then
				local min = math.floor(remaining / 60000)
				local sec = math.floor((remaining % 60000) / 1000)
				vim.notify(string.format("⏱ %d:%02d remaining", min, sec))
			else
				vim.notify("No active countdown")
			end
		else
			vim.notify("No active countdown")
		end
		return
	end
	if countdown_state.timer then
		countdown_state.timer:stop()
	end
	countdown_state.timer = vim.loop.new_timer()
	countdown_state.end_time = vim.loop.now() + minutes * 60 * 1000
	vim.notify(string.format("⏱ Countdown %d min started", minutes))
	countdown_state.timer:start(
		minutes * 60 * 1000,
		0,
		vim.schedule_wrap(function()
			vim.fn.system('notify-send "Neovim" "⏰ Time is up!"')
			vim.notify("⏰ Time is up!", vim.log.levels.WARN)
			countdown_state.timer:stop()
			countdown_state.timer = nil
			countdown_state.end_time = nil
		end)
	)
end, { nargs = "?" })

vim.api.nvim_create_user_command("CountdownStop", function()
	if countdown_state.timer then
		countdown_state.timer:stop()
		countdown_state.timer = nil
		countdown_state.end_time = nil
		vim.notify("⏱ Countdown cancelled")
	else
		vim.notify("No active countdown")
	end
end, {})
