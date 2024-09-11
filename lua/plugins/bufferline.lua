return {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = function()
        local keymap = {
            {
                "<a-h>",
                function()
                    require("bufferline").cycle(-1)
                end,
                desc = "Go to previous buffer (Bufferline)",
            },
            {
                "<a-l>",
                function()
                    require("bufferline").cycle(1)
                end,
                desc = "Go to next buffer (Bufferline)",
            },
            {
                "<a-0>",
                function()
                    require("bufferline").go_to(0)
                end,
                desc = "Go to last buffer (Bufferline)",
            },
        }

        for i = 1, 9, 1 do
            table.insert(keymap, {
                "<a-" .. i .. ">",
                function()
                    require("bufferline").go_to(i)
                end,
                desc = "Go to buffer #" .. i .. " (Bufferline)",
            })
        end

        return keymap
    end,
    opts = function(_, opts)
        local bufremove = require("mini.bufremove")

        opts.options = {
            separator_style = {},
            indicator = { style = "none" },
            numbers = function(num)
                return string.format(
                    "%s·%s",
                    num.raise(num.id),
                    num.lower(num.ordinal)
                )
            end,
            close_command = function(n)
                bufremove.delete(n, false)
            end,
            right_mouse_command = function(n)
                bufremove.delete(n, true)
            end,
            always_show_bufferline = false,
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(_, _, diagnostics_dict)
                local icon = require("config").icons.diagnostics
                local s = " "
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and icon.Error
                        or (e == "warning" and icon.Warn or icon.Info)
                    s = s .. n .. sym
                end
                return s
            end,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Neo-Tree",
                    highlight = "BufferLineOffset",
                },
            },
        }
    end,
}
