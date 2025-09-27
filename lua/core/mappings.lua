require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>q", "<cmd>q!<CR>", { desc = "quit force" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "save file" })
