return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    { "Bilal2453/luvit-meta", lazy = true },

    {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
            local global = opts.global
            global.sources = global.sources or {}
            table.insert(global.sources, { name = "lazydev", group_index = 0 })
        end,
    },
}
