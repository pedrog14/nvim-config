return {
    {
        "echasnovski/mini.bufremove",
        event = "VeryLazy",
        keys = {
            {
                "<a-x>",
                function()
                    local bufremove = require("mini.bufremove")
                    if vim.bo.modified then
                        local choice =
                            vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                        if choice == 1 then -- Yes
                            vim.cmd.write()
                            bufremove.delete(0)
                        elseif choice == 2 then -- No
                            bufremove.delete(0, true)
                        end
                    else
                        bufremove.delete(0)
                    end
                end,
                desc = "Delete buffer",
            },
            {
                "<a-X>",
                function()
                    local bufremove = require("mini.bufremove")
                    bufremove.delete(0, true)
                end,
                desc = "Delete buffer (FORCE)",
            },
        },
        opts = {},
    },

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
        "echasnovski/mini.pairs",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            modes = { insert = true, command = true, terminal = false },
        },
    },

    {
        "echasnovski/mini.surround",
        event = { "BufNewFile", "BufReadPre" },
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
        },
    },
}
