return {
    "akinsho/bufferline.nvim",
    dependencies = "folke/snacks.nvim",
    event = "VeryLazy",
    opts = function()
        vim.api.nvim_set_hl(0, "BufferLineOffsetTitle", {
            link = "Title",
            default = true,
        })

        ---@module "bufferline"
        ---@type bufferline.Config
        return { --[[@diagnostic disable-line: missing-fields]]
            options = {
                always_show_bufferline = false,
                diagnostics = "nvim_lsp",
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-Tree",
                        highlight = "BufferLineOffsetTitle",
                        text_align = "left",
                    },
                    {
                        filetype = "snacks_layout_box",
                    },
                },
                close_command = function(n)
                    Snacks.bufdelete(n)
                end,
                right_mouse_command = function(n)
                    Snacks.bufdelete(n)
                end,
                numbers = function(num)
                    return ("%s·%s"):format(
                        num.raise(num.id), --[[@diagnostic disable-line: undefined-field]]
                        num.lower(num.ordinal) --[[@diagnostic disable-line: undefined-field]]
                    )
                end,
                diagnostics_indicator = function(_, _, diagnostics_dict)
                    local sign_icon = require("utils.icons").diagnostic.signs
                    local indicator = ""
                    for diagnostic_type, number in pairs(diagnostics_dict) do
                        local icon = diagnostic_type == "error" and sign_icon.error
                            or (diagnostic_type == "warning" and sign_icon.warn or sign_icon.info)
                        indicator = ("%s%s%s "):format(indicator, icon, number)
                    end
                    return vim.trim(indicator)
                end,
            },
        }
    end,
}
