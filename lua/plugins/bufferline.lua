return {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
        {
            "<a-h>",
            function()
                require("bufferline").cycle(-1)
            end,
            desc = "Go to previous buffer (BufferLine)",
        },
        {
            "<a-l>",
            function()
                require("bufferline").cycle(1)
            end,
            desc = "Go to next buffer (BufferLine)",
        },
    },
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
            -- diagnostics_indicator = function(_, _, diag)
            --     local icons = require("config").icons.diagnostics
            --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            --         .. (diag.warning and icons.Warn .. diag.warning or "")
            --     return vim.trim(ret)
            -- end,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Neo-Tree",
                    highlight = "BufferLineOffset",
                    -- separator = "│",
                },
            },
        }
    end,
}
