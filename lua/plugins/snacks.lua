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
    ---@param opts snacks.Config
    opts = function(_, opts)
        local icons = require("utils.icons").diagnostics

        opts.bigfile = { enabled = true }
        opts.quickfile = { enabled = true }
        opts.statuscolumn = { enabled = true }
        opts.words = { enabled = true }

        opts.dashboard = {
            preset = {
                keys = {
                    { icon = "󰈔", desc = "New File", key = "n", action = ":ene | startinsert" },
                    { icon = "󰈞", desc = "Find File", key = "f", action = ":Telescope find_files" },
                    { icon = "󱋡", desc = "Recent Files", key = "o", action = ":Telescope oldfiles" },
                    { icon = "󱁻", desc = "Config Files", key = "c", action = ":exec 'Neotree' stdpath('config')" },
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
        }

        opts.notifier = {
            icons = {
                error = icons.error,
                warn = icons.warn,
                info = icons.info,
            },
            notify_lsp_progress = true,
            timeout = 5000,
        }

        opts.lazygit = {
            win = {
                backdrop = 100,
            },
        }

        opts.styles = {
            notification = {
                wo = { wrap = true },
            },
        }
    end,
}
