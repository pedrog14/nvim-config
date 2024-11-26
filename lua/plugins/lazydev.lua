return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
            integrations = { cmp = false },
        },
    },

    { "Bilal2453/luvit-meta", lazy = true },
}
