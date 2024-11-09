return {
    "akinsho/bufferline.nvim",
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
    ---@param opts bufferline.Config
    opts = function(_, opts)
        local bufremove = require("mini.bufremove")

        vim.api.nvim_set_hl(0, "BufferLineOffsetTitle", {
            link = "Title",
            default = true,
        })

        opts.options = {
            numbers = function(num)
                ---@diagnostic disable-next-line: undefined-field
                return string.format("%s·%s", num.raise(num.id), num.lower(num.ordinal))
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
                local icons = require("utils").icons.diagnostics
                local s = " "
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and icons.error or (e == "warning" and icons.warn or icons.info)
                    s = s .. n .. sym
                end
                return s
            end,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Neo-Tree",
                    highlight = "BufferLineOffsetTitle",
                    text_align = "left",
                },
            },
        }
    end,
}
