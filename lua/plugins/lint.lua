return {
    "mfussenegger/nvim-lint",
    event = { "BufNewFile", "BufReadPre" },
    main = "utils.plugins.lint",
    opts = {
        linters_by_ft = {},
    },
}
