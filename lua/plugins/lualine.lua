return {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = function(_, opts)
        local symbols = require("config").icons.diagnostics

        vim.o.laststatus = vim.g.lualine_laststatus

        opts.options = {
            theme = "auto",
            globalstatus = vim.o.laststatus == 3,
            disabled_filetypes = { statusline = { "dashboard" } },
        }
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
            "toggleterm",
        }
    end,
}
