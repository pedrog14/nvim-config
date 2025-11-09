return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        ---@module "lazydev"
        ---@type lazydev.Config
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "Saghen/blink.cmp",
        optional = true,
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            sources = {
                per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
        },
    },
}
