return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        indent = { char = "▏", tab_char = "▏" },
        scope = {
            show_start = false,
            show_end = false,
            include = {
                node_type = { lua = { "table_constructor", "expression_list" } },
            },
        },
        exclude = {
            filetypes = {
                "Trouble",
                "help",
                "lazy",
                "mason",
                "notify",
                "snacks_dashboard",
                "snacks_notif",
                "snacks_terminal",
                "snacks_win",
                "trouble",
            },
        },
    },
}
