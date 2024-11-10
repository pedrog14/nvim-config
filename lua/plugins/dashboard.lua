return {
    "nvimdev/dashboard-nvim",
    lazy = false,
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

        ---@type DashboardCenter[]
        local center = {
            { "󰈔", " 󰁔 New File", "n", "ene | startinsert" },
            {
                "󰈞",
                " 󰁔 Find File",
                "f",
                function()
                    require("telescope.builtin").find_files()
                end,
            },
            {
                "󱋡",
                " 󰁔 Recent Files",
                "o",
                function()
                    require("telescope.builtin").oldfiles()
                end,
            },
            {
                "󱁻",
                " 󰁔 Config Files",
                "c",
                function()
                    require("neo-tree.command").execute({ dir = vim.fn.stdpath("config") })
                end,
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
