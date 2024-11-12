return {
    "stevearc/conform.nvim",
    dependencies = "pedrog14/mason-conform.nvim",
    cmd = "ConformInfo",
    event = { "BufNewFile", "BufReadPre" },
    main = "utils.plugins.conform",
    opts = function(_, opts)
        opts.default_format_opts = { lsp_format = "fallback" }
        opts.format_on_save = { lsp_format = "fallback", timeout_ms = 500 }
        opts.handlers = {
            function(formatter_name)
                require("conform").formatters_by_ft = require("mason-conform").formatter_handler(formatter_name)
            end,
        }
    end,
}
