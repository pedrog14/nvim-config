return {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
        {
            "<c-/>",
            function()
                require("toggleterm").toggle()
            end,
            desc = "Toggle Terminal",
        },
    },
    opts = {
        shade_terminals = false,
    },
}
