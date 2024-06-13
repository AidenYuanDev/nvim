local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "starry.lsp.mason"
require("starry.lsp.handlers").setup()
require "starry.lsp.null-ls"
