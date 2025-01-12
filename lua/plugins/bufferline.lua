return {
    "akinsho/bufferline.nvim",
    dependencies = "folke/snacks.nvim",
    event = "VeryLazy",
    opts = function()
        vim.api.nvim_set_hl(0, "BufferLineOffsetTitle", {
            link = "Title",
            default = true,
        })

        ---@type bufferline.Config
        ---@diagnostic disable-next-line: missing-fields
        return {
            options = {
                numbers = function(num)
                    return ("%s·%s"):format(
                        num.raise(num.id), ---@diagnostic disable-line: undefined-field
                        num.lower(num.ordinal) ---@diagnostic disable-line: undefined-field
                    )
                end,
                close_command = function(n)
                    Snacks.bufdelete(n)
                end,
                right_mouse_command = function(n)
                    Snacks.bufdelete(n)
                end,
                always_show_bufferline = false,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diagnostics_dict)
                    local icons = require("utils").icons.diagnostics
                    local indicator = ""
                    for diagnostic_type, number in pairs(diagnostics_dict) do
                        local icon = diagnostic_type == "error" and icons.error
                            or (
                                diagnostic_type == "warning" and icons.warn
                                or icons.info
                            )
                        indicator = ("%s%s%s "):format(indicator, icon, number)
                    end
                    return vim.trim(indicator)
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
