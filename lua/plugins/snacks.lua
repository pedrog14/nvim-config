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
        {
            "gR",
            function()
                require("snacks").rename.rename_file()
            end,
            desc = "Rename file",
        },
        {
            "[[",
            function()
                require("snacks").words.jump(-vim.v.count1)
            end,
            desc = "Previous Reference",
            mode = { "n", "t" },
        },
        {
            "]]",
            function()
                require("snacks").words.jump(vim.v.count1)
            end,
            desc = "Next Reference",
            mode = { "n", "t" },
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    require("snacks").debug.inspect(...)
                end
                _G.bt = function()
                    require("snacks").debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command
            end,
        })
    end,
    main = "utils.plugins.snacks",
    opts = function()
        local icons = require("utils.icons").diagnostics
        ---@type snacks.Config
        return {
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            dashboard = {
                preset = {
                    keys = {
                        { icon = "󰈔", desc = "New File", key = "n", action = ":ene | startinsert" },
                        { icon = "󰈞", desc = "Find File", key = "f", action = ":Telescope find_files" },
                        { icon = "󱋡", desc = "Recent Files", key = "o", action = ":Telescope oldfiles" },
                        {
                            icon = "󱁻",
                            desc = "Config Files",
                            key = "c",
                            action = ":exec 'Neotree' stdpath('config')",
                        },
                        { icon = "󰒲", desc = "Lazy", key = "l", action = ":Lazy", enabled = package.loaded.lazy },
                        { icon = "󰏓", desc = "Mason", key = "m", action = ":Mason" },
                        { icon = "", desc = "Exit Neovim", key = "q", action = ":quitall" },
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
            },
        }
    end,
}
