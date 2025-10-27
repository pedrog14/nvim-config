return {
    "mfussenegger/nvim-lint",
    event = { "BufNewFile", "BufWritePre", "BufReadPost" },
    main = "utils.plugins.lint",
    opts = {
        linters_by_ft = {},
    },
}
