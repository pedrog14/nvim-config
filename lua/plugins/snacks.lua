return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    keys = {
        {
            "<a-x>",
            function()
                require("snacks").bufdelete()
            end,
            desc = "Delete Buffer",
        },
    },
    main = "utils.plugins.snacks",
    opts = function(_, opts)
        local icons = require("utils").icons.diagnostics

        ---@type snacks.notifier.Notif.opts
        opts.notifier = {
            icons = {
                error = icons.error,
                warn = icons.warn,
                info = icons.info,
            },
            notify_lsp_progress = true,
        }
        ---@type snacks.lazygit.Config
        opts.lazygit = {
            win = {
                backdrop = 100,
            },
        }
    end,
}
