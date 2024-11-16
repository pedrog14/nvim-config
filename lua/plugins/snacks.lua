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
    ---@param opts snacks.Config
    opts = function(_, opts)
        local icons = require("utils.icons").diagnostics

        opts.bigfile = { enabled = true }
        opts.quickfile = { enabled = true }
        opts.statuscolumn = { enabled = true }
        opts.words = { enabled = true }

        opts.notifier = {
            icons = {
                error = icons.error,
                warn = icons.warn,
                info = icons.info,
            },
            notify_lsp_progress = true,
        }

        opts.lazygit = {
            win = {
                backdrop = 100,
            },
        }
    end,
}
