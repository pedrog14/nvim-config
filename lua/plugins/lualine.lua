return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local snacks_picker = {
            sections = {
                lualine_a = {
                    function()
                        return "Snacks.picker"
                    end,
                },
            },
            filetypes = {
                "snacks_picker_input",
                "snacks_picker_list",
                "snacks_picker_preview",
            },
        }
        local snacks_terminal = {
            sections = {
                lualine_a = {
                    function()
                        return "Snacks.terminal"
                    end,
                },
            },
            filetypes = { "snacks_terminal" },
        }

        local diagnostic_icons = require("utils.icons").diagnostic
        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "snacks_dashboard" },
                },
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    { "diagnostics", symbols = diagnostic_icons },
                },
            },
            extensions = {
                "lazy",
                "mason",
                "neo-tree",
                "quickfix",
                snacks_picker,
                snacks_terminal,
            },
        }
    end,
}
