return {
  "neovim/nvim-lspconfig",
  config = function()
    local nvlsp = require "nvchad.configs.lspconfig"
    nvlsp.defaults()

    vim.lsp.enable { "gopls", "yamlls", "pyright", "jsonls", "clangd" }

    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            test = true,
            tidy = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            functionTypeParameters = true,
            parameterNames = true,
          },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-**/node_modules", "-**/dist" },
        },
      },
    })

    local ok_js, schemastore = pcall(require, "schemastore")
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          validate = { enable = true },
          format = { enable = false }, -- 交给 conform/prettier
          schemas = ok_js and schemastore.json.schemas() or nil,
        },
      },
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          format = { enable = false },
          validate = true,
          hover = true,
          completion = true,
          keyOrdering = false,
          schemaStore = { enable = true, url = "" },
          schemas = ok_js and schemastore.yaml.schemas() or nil,
        },
      },
    })

    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            -- typeCheckingMode = "basic",
          },
        },
      },
    })

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--offset-encoding=utf-8",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--all-scopes-completion",
        "--pch-storage=memory", -- NFS/远程盘建议开启
      },
      -- 0.11 的新字段：用 root_markers 指定项目根标记（可替代 util.root_pattern）
      root_markers = { "compile_commands.json", ".clangd", ".git" },
      filetypes = { "c", "cpp", "objc", "objcpp" },
    })
  end,
}
