return {
    "folke/snacks.nvim",
    opts = function(_, opts)
        local diagnostic_icons = require("utils.icons").diagnostic
        opts.picker = {
            prompt = "󰁔 ",
            layout = { layout = { backdrop = false } },
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
