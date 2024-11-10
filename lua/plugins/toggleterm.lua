return {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
        {
            "<leader>t",
            function()
                require("toggleterm").toggle()
            end,
            desc = "Terminal Toggle",
        },
    },
    opts = {
        shade_terminals = false,
    },
}
