return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
            integrations = { cmp = vim.fn.has("nvim-0.11.0") ~= 1 },
        },
    },

    { "Bilal2453/luvit-meta", lazy = true },

    {
        "hrsh7th/nvim-cmp",
        enabled = vim.fn.has("nvim-0.11.0") ~= 1,
        optional = true,
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, { name = "lazydev", group_index = 0 })
        end,
    },
}
