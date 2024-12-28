return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command
            end,
        })
    end,
    main = "utils.plugins.snacks",
    opts = function()
        local icons = require("utils").icons.diagnostics
        return {
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            indent = {
                filter = { filetype = { "text" } },
            },
            input = { enabled = true, icon = "󰁔" },
            notifier = {
                icons = {
                    error = icons.error,
                    warn = icons.warn,
                    info = icons.info,
                },
                notify_lsp_progress = true,
            },
            styles = {
                notification = {
                    wo = { wrap = true, winblend = 0 },
                },
                lazygit = {
                    backdrop = 100,
                },
                input = {
                    keys = {
                        esc = { "<esc>", "cancel" },
                        i_esc = { "<esc>", "stopinsert", mode = "i" },
                        i_cr = { "<cr>", "confirm", mode = "i" },
                    },
                },
            },
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
                                require("telescope.builtin").find_files()
                            end,
                        },
                        {
                            icon = "󱋡",
                            desc = "Recent Files",
                            key = "o",
                            action = function()
                                require("telescope.builtin").oldfiles()
                            end,
                        },
                        {
                            icon = "󱁻",
                            desc = "Config Files",
                            key = "c",
                            action = function()
                                require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
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
                formats = {
                    key = { "[%s]" },
                },
                sections = {
                    {
                        header = table.concat({
                            "██████████████████████████████████████████████████",
                            "█████ ████████████████████████████████████████",
                            "████   ███  ████████████████  █ ███████████",
                            "███     █     █     ██  ████ █ ███",
                            "██  █       ██ ██    █        ██",
                            "██  ███   █   ██ ██ █   █  █ █  ██",
                            "███████ ██    █    ███ █  █████ ██",
                            "██████████████████████████████████████████████████",
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
        }
    end,
}
