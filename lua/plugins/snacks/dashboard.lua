return {
    "folke/snacks.nvim",
    optional = true,
    opts = {
        dashboard = {
            preset = {
                keys = {
                    {
                        icon = "󰈔",
                        desc = "New File",
                        key = "n",
                        action = ":ene | startinsert",
                    },
                    {
                        icon = "󰈞",
                        desc = "Find File",
                        key = "f",
                        action = function()
                            Snacks.picker.files()
                        end,
                    },
                    {
                        icon = "󱋡",
                        desc = "Recent Files",
                        key = "r",
                        action = function()
                            Snacks.picker.recent()
                        end,
                    },
                    {
                        icon = "󱁻",
                        desc = "Config Files",
                        key = "c",
                        action = function()
                            Snacks.picker.files({ ---@diagnostic disable-line: missing-fields
                                cwd = vim.fn.stdpath("config"), ---@diagnostic disable-line: assign-type-mismatch
                                title = "Config Files",
                            })
                        end,
                    },
                    {
                        icon = "󰒲",
                        desc = "Lazy",
                        key = "l",
                        action = function()
                            require("lazy").show()
                        end,
                    },
                    {
                        icon = "󰏓",
                        desc = "Mason",
                        key = "m",
                        action = function()
                            require("mason.ui").open()
                        end,
                    },
                    {
                        icon = "󰈆",
                        desc = "Exit Neovim",
                        key = "q",
                        action = ":quitall",
                    },
                },
            },
            formats = { key = { "[%s]" } },
            sections = {
                {
                    header = table.concat({
                        "████████████████████████████████████████████████████",
                        "█████ ██████████████████████████████████████████",
                        "████   ███  ████████████ █████ █ ██ ████",
                        "███     █     █      ██ ███      ███",
                        "██  █       ██ ██               ██",
                        "██  ███   █   ██ ██ █      █  █  ██",
                        "███████ ██    █    ███ █ █  ███████ ██",
                        "████████████████████████████████████████████████████",
                    }, "\n"),
                    padding = 2,
                },
                { section = "keys", gap = 1, padding = 2 },
                {
                    footer = table.concat({
                        "I think we can put our differences behind us.",
                        "For science. You monster. - GLaDOS",
                    }, "\n"),
                },
            },
        },
    },
}
