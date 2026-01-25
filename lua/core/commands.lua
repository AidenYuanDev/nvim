-- Countdown timer
vim.api.nvim_create_user_command("Countdown", function(opts)
	local minutes = tonumber(opts.args) or 5
	local timer = vim.loop.new_timer()
	vim.notify(string.format("⏱ 倒计时 %d 分钟开始", minutes))
	timer:start(
		minutes * 60 * 1000,
		0,
		vim.schedule_wrap(function()
			vim.fn.system('notify-send "Neovim" "⏰ 时间到！"')
			vim.notify("⏰ 时间到！", vim.log.levels.WARN)
			timer:stop()
		end)
	)
end, { nargs = "?" })
