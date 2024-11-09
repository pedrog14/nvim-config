return {
    "nvimdev/dashboard-nvim",
    lazy = false,
    keys = {
        {
            "<leader>ds",
            function()
                require("dashboard"):instance()
            end,
            desc = "Open Dashboard",
        },
    },
    main = "utils.plugins.dashboard",
    opts = function(_, opts)
        local header = {
            "██████████████████████████████████████████████████\n",
            "█████ ████████████████████████████████████████\n",
            "████   ███  ████████████████  █ ███████████\n",
            "███     █     █     ██  ████ █ ███\n",
            "██  █       ██ ██    █        ██\n",
            "██  ███   █   ██ ██ █   █  █ █  ██\n",
            "███████ ██    █    ███ █  █████ ██\n",
            "██████████████████████████████████████████████████\n",
        }

        ---@type DashboardCenter
        local center = {
            { "󰈔", " 󰁔 New File", "n", "ene | startinsert" },
            { "󰈞", " 󰁔 Find File", "f", "lua require('telescope.builtin').find_files()" },
            { "󱋡", " 󰁔 Recent Files", "o", "lua require('telescope.builtin').oldfiles()" },
            {
                "󱁻",
                " 󰁔 Config Files",
                "c",
                ("lua require('neo-tree.command').execute({ dir = '%s' })"):format(vim.fn.stdpath("config")),
            },
            { "󰒲", " 󰁔 Lazy", "l", "Lazy" },
            { "󰏓", " 󰁔 Mason", "m", "Mason" },
            { "󰗼", " 󰁔 Exit Neovim", "q", "quitall" },
        }

        local footer = {
            "I think we can put our differences behind us.\n",
            "For science. You monster. - GLaDOS",
        }

        local config = {
            header = header,
            center = center,
            footer = footer,
        }

        opts.theme = "doom"
        opts.hide = { statusline = false }
        opts.config = config
    end,
}
