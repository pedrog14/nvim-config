return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        {
            "<leader>tt",
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
