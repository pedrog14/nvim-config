return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
            integrations = { cmp = false },
        },
    },

    { "Bilal2453/luvit-meta", lazy = true },
}
