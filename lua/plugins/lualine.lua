return {
    "nvim-lualine/lualine.nvim",
    dependencies = "echasnovski/mini.icons",
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
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local icons = require("utils.icons").diagnostics

        vim.o.laststatus = vim.g.lualine_laststatus

        opts.options = {
            theme = "auto",
            globalstatus = vim.o.laststatus == 3,
            disabled_filetypes = { statusline = { "snacks_dashboard" } },
        }
        opts.sections = {
            lualine_b = {
                "branch",
                "diff",
                {
                    "diagnostics",
                    symbols = {
                        error = icons.error,
                        warn = icons.warn,
                        info = icons.info,
                        hint = icons.hint,
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
