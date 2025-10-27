return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufNewFile", "BufWritePre", "BufReadPost" },
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        indent = { char = "▏" },
        scope = {
            show_start = false,
            show_end = false,
            include = {
                node_type = { ["lua"] = { "table_constructor" } },
            },
        },
    },
}
