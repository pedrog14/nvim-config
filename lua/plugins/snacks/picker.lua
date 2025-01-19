return {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
        local diagnostic_icons = require("utils.icons").diagnostic
        opts.picker = {
            prompt = "󰁔 ",
            layout = {
                layout = {
                    backdrop = false,
                    box = "horizontal",
                    width = 0.8,
                    min_width = 120,
                    height = 0.8,
                    {
                        box = "vertical",
                        border = "rounded",
                        title = "{source} {live} {flags}",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                    },
                    {
                        win = "preview",
                        title = "{preview}",
                        border = "rounded",
                        width = 0.5,
                    },
                },
            },
            icons = {
                diagnostics = {
                    Error = diagnostic_icons.error,
                    Warn = diagnostic_icons.warn,
                    Hint = diagnostic_icons.hint,
                    Info = diagnostic_icons.info,
                },
            },
        }
    end,
}
