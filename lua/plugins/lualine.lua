return {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = function(_, opts)
        local symbols = require("config").icons.diagnostics
        opts.sections = {
            lualine_b = {
                "branch",
                "diff",
                {
                    "diagnostics",
                    symbols = {
                        error = symbols.Error,
                        warn = symbols.Warn,
                        hint = symbols.Hint,
                        info = symbols.Info,
                    },
                },
            },
        }
        opts.extensions = {
            "lazy",
            "mason",
            "neo-tree",
            "trouble",
        }
    end,
}
