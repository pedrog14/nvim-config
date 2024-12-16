return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = { enabled = false },
        select = {
            telescope = {
                results_title = false,
                sorting_strategy = "ascending",
                layout_strategy = "vertical",
                layout_config = {
                    anchor = "N",
                    prompt_position = "top",
                    width = function(_, max_columns, _)
                        return math.min(max_columns, 80)
                    end,
                    height = function(_, _, max_lines)
                        return math.min(max_lines, 15)
                    end,
                },
            },
        },
    },
}
