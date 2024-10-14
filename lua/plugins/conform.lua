return {
    {
        "stevearc/conform.nvim",
        dependencies = "pedrog14/mason-conform.nvim",
        opts = function(_, opts)
            opts.format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        end,
    },

    {
        "pedrog14/mason-conform.nvim",
        opts = function(_, opts)
            opts.handlers = require("mason-conform").default_handlers
        end,
    },
}
