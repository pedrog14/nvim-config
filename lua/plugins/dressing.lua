return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = {
            trim_prompt = false,
            title_pos = "center",
        },
        select = {
            telescope = {
                layout_strategy = "vertical",
            },
        },
    },
}
