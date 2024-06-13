local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

-- 把leader改成空格
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- 切换窗口
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- 调整窗口大小
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- 窗口管理
keymap("n", "<leader>sv", "<C-w>v", opts)         -- 垂直分割窗口
keymap("n", "<leader>sh", "<C-w>s", opts)         -- 水平分割窗口
keymap("n", "<leader>se", "<C-w>=", opts)         -- 确保分割的窗口大小相同
keymap("n", "<leader>sx", "<cmd>close<CR>", opts) -- 关闭当前窗口

-- 清除高亮
keymap("n", "<leader>nh", ":nohl<CR>", opts)

-- Visual --
-- 移动选中文本
-- 缩进
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
-- 上下移动
keymap('v', 'J', ":move '>+1<CR>gv-gv", opts)
keymap('v', 'K', ":move '<-2<CR>gv-gv", opts)
keymap("v", "p", '"_dP', opts)

-- Null-ls
keymap("n", "<leader>f", ":Format<cr>", opts)
