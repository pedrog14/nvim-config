return {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
        local diagnostic_icons = require("utils.icons").diagnostic
        opts.notifier = {
            icons = { warn = diagnostic_icons.warn },
            notify_lsp_progress = true,
        }
    end,
}