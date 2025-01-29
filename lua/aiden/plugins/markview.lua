return {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("markview").setup({
            preview = {
                modes = { "n", "i" },
                callbacks = {
                    on_enable = function(_, win)
                        vim.wo[win].conceallevel = 2
                        vim.wo[win].concealcursor = "nc"
                    end,
                },
            },
            markdown = {
                headings = {
                    enable = true,
                },
                horizontal_rules = {
                    parts = {},
                },
            },
        })
    end,
}
