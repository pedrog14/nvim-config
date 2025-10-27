return {
    "folke/todo-comments.nvim",
    event = { "BufNewFile", "BufReadPre" },
    keys = {
        {
            "]t",
            function()
                require("todo-comments").jump_next()
            end,
            desc = "Next Todo Comment",
        },
        {
            "[t",
            function()
                require("todo-comments").jump_prev()
            end,
            desc = "Previous Todo Comment",
        },
    },
    ---@module "todo-comments"
    ---@type TodoOptions
    opts = { signs = false },
}
