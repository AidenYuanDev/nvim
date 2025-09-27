return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  config = function()
    local conform = require "conform"
    conform.setup {
      formatters_by_ft = {
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        go = { "gofumpt", "goimports" },
        python = { "ruff_organize_imports", "ruff_format" },
        lua = { "stylua" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        toml = { "taplo" },
        xml = { "xmlformat" },
        protobuf = { "buf" },
      },

      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,

      formatters = {
        ["clang-format"] = {
          prepend_args = { "--style=Chromium" },
        },
        ["ruff_organize_imports"] = {
          command = "ruff",
          args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
        ["ruff_format"] = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
        ["shfmt"] = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },
    }
  end,
}
