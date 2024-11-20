return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufNewFile", "BufReadPre" },
    main = "ibl",
    opts = {
        exclude = {
            filetypes = { "help" },
        },
    },
}
