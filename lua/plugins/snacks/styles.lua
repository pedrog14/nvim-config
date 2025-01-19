return {
    "folke/snacks.nvim",
    optional = true,
    opts = {
        styles = {
            notification = { wo = { wrap = true, winblend = 0 } },
            lazygit = { backdrop = false, border = "rounded" },
            input = {
                keys = {
                    i_esc = { "<esc>", "stopinsert", mode = "i" },
                    i_cr = { "<cr>", "confirm", mode = "i" },
                },
            },
        },
    },
}
