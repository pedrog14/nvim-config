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

        local symbols, signs = {}, require("utils.icons").diagnostic.signs
        for i, type in ipairs({ "error", "warn", "info", "hint" }) do
            symbols[type] = signs[i]
        end

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
                    { "diagnostics", symbols = symbols },
                },
            },
            extensions = {
                "lazy",
                "mason",
                "neo-tree",
                "quickfix",
                snacks_picker,
            },
        }
    end,
}
