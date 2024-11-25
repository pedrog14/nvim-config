return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    { "Bilal2453/luvit-meta", lazy = true },

    {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, { name = "lazydev", group_index = 0 })
        end,
    },
}
