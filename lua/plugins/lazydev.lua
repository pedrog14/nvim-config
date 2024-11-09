return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {},
    },

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
