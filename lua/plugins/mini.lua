return {
    {
        "echasnovski/mini.icons",
        lazy = true,
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        opts = {},
    },

    {
        "echasnovski/mini.hipatterns",
        event = { "BufNewFile", "BufReadPre" },
        opts = function()
            local hipatterns = require("mini.hipatterns")
            local utils = require("utils").plugins.mini.hipatterns
            return {
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color({
                        priority = 2000,
                    }),
                    hex_alpha_color = utils.hex_alpha_color({ priority = 2000 }),
                    shorthand = utils.shorthand({ priority = 2000 }),
                },
            }
        end,
    },

    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        main = "utils.plugins.mini.pairs",
        opts = {
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { "string" },
            skip_unbalanced = true,
            markdown = true,
        },
    },

    {
        "echasnovski/mini.surround",
        event = { "BufNewFile", "BufReadPre" },
        opts = {
            mappings = {
                add = "gs", -- Add surrounding in Normal and Visual modes
                delete = "ds", -- Delete surrounding
                replace = "cs", -- Replace surrounding

                find = "", -- Find surrounding (to the right)
                find_left = "", -- Find surrounding (to the left)
                highlight = "", -- Highlight surrounding
                update_n_lines = "", -- Update `n_lines`

                suffix_last = "",
                suffix_next = "",
            },
            search_method = "cover_or_next",
        },
    },
}
