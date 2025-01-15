return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local symbols = require("utils").icons.diagnostics
        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "snacks_dashboard", "snacks_picker_input" },
                },
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    { "diagnostics", symbols = symbols },
                },
            },
            extensions = { "lazy", "mason", "neo-tree", "quickfix" },
        }
    end,
}
