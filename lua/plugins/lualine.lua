return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local icons = require("utils").icons.diagnostics

        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "snacks_dashboard" } },
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.error .. " ",
                            warn = icons.warn .. " ",
                            info = icons.info .. " ",
                            hint = icons.hint .. " ",
                        },
                    },
                },
            },
            extensions = {
                "lazy",
                "mason",
                "neo-tree",
                "quickfix",
                "toggleterm",
            },
        }
    end,
}
