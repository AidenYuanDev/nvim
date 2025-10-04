require("nvchad.options")

local o = vim.o

o.relativenumber = true

vim.g.vscode_snippets_path = vim.fn.stdpath("config") .. "/snippets"
