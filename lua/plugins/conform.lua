return {
    {
        "stevearc/conform.nvim",
        opts = {
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        },
    },

    {
        "pedrog14/mason-conform.nvim",
        opts = function(_, opts)
            opts.handlers = require("mason-conform").default_handlers()
        end,
    },
}
