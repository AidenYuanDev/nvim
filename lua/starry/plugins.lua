local fn = vim.fn

-- 自动安装packer插件
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- 输入:w，更新插件
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- 第一次进入，首先安装插件
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- 使用 popup 窗口
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})


-- 安装插件
return packer.startup(function(use)
    -- 插件管理器
    use "wbthomason/packer.nvim"
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"
    use 'rstacruz/vim-closer'
    use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

    -- colorscheme
    use { "catppuccin/nvim", as = "catppuccin" }
    -- use {"folke/tokyonight.nvim"}

    -- cmp 自动补全
    use "hrsh7th/nvim-cmp"      -- The completion plugin
    use "hrsh7th/cmp-buffer"    -- buffer completions
    use "hrsh7th/cmp-path"      -- path completions
    use "hrsh7th/cmp-cmdline"   -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    -- snippets
    use "L3MON4D3/LuaSnip"          --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
    use "neovim/nvim-lspconfig"          -- enable LSP
    use "williamboman/mason.nvim"        -- simple to use language server installer
    use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
    use 'jose-elias-alvarez/null-ls.nvim' -- LSP diagnostics and code actions

    -- 括号颜色
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use "p00f/nvim-ts-rainbow"
    -- 括号配对
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
    -- 注释
    use "JoosepAlviste/nvim-ts-context-commentstring"

    -- nvim-tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    -- Telescope
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        }
    }

    -- nvim 界面美化
    use {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
        end
    }

    -- 状态栏
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- gitsigns
    use { "lewis6991/gitsigns.nvim" }

    -- Copilot
    use {"github/copilot.vim"}

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
