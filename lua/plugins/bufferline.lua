return {
    "akinsho/bufferline.nvim",
    dependencies = "folke/snacks.nvim",
    event = { "BufNewFile", "BufReadPre" },
    keys = function()
        local keys = {
            {
                "<a-h>",
                function()
                    require("bufferline").cycle(-1)
                end,
            },
            {
                "<a-l>",
                function()
                    require("bufferline").cycle(1)
                end,
            },
        }
        for i = 0, 9 do
            keys[#keys + 1] = {
                ("<a-%i>"):format(i),
                function()
                    require("bufferline").go_to(i)
                end,
            }
        end
        return keys
    end,

    opts = function()
        local bufdelete = require("snacks").bufdelete

        vim.api.nvim_set_hl(0, "BufferLineOffsetTitle", {
            link = "Title",
            default = true,
        })

        ---@type bufferline.Config?
        ---@diagnostic disable-next-line: missing-fields
        return {
            options = {
                numbers = function(num)
                    ---@diagnostic disable-next-line: undefined-field
                    return ("%s·%s"):format(num.raise(num.id), num.lower(num.ordinal))
                end,
                close_command = function(n)
                    bufdelete(n)
                end,
                right_mouse_command = function(n)
                    bufdelete(n)
                end,
                always_show_bufferline = false,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diagnostics_dict)
                    local icons = require("utils.icons").diagnostics
                    local indicator = ""
                    for diagnostic_type, number in pairs(diagnostics_dict) do
                        local icon = diagnostic_type == "error" and icons.error
                            or (diagnostic_type == "warning" and icons.warn or icons.info)
                        indicator = ("%s%s%s "):format(indicator, number, icon)
                    end
                    return indicator
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-Tree",
                        highlight = "BufferLineOffsetTitle",
                        text_align = "left",
                    },
                },
            },
        }
    end,
}
