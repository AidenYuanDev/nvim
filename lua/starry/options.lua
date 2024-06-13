vim.cmd("let g:netrw_liststyle = 3")		-- 设置目录列表的样式：树形

local opt = vim.opt

opt.relativenumber = true		            -- 设置相对行数
opt.number = true			                -- 显示光标上的绝对行号
opt.tabstop = 4 			                -- 缩进为4个空格
opt.shiftwidth = 4 		                	-- 4个空格为缩进
opt.expandtab = true 			            -- 把缩进变成空格
opt.autoindent = true			            -- 换行时，自动继承当前行的缩进
opt.wrap = false			                -- 禁用换行
opt.ignorecase = true			            -- 查找时，忽略大小写
opt.smartcase = true		            	-- 可以查找到既有大写又有小写
opt.cursorline = true			            -- 高亮当前行
opt.backspace = "indent,eol,start"	        -- 允许在缩进、行尾或插入模式起始位置上退格
opt.splitright = true		            	-- 向右拆分
opt.splitbelow = true		            	-- 水平拆分
opt.mouse = "a"                             -- 允许使用鼠标
-- opt.transparent = true                       -- 背景透明

-- 剪切板  会使打开速度变慢
opt.clipboard = {
    name = 'win32yank-wsl',
    copy = {
        ['+'] =  'win32yank.exe -i --crlf',
        ['*'] =  'win32yank.exe -i --crlf',
    },
    paste = {
        ['+'] = 'win32yank.exe -o --lf',
        ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = true,
}
opt.clipboard:append("unnamedplus")   	-- 使用系统默认剪贴板
