return {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = "Trouble",
    keys = function()
        local toggle = require("trouble").toggle
        return {
            {
                "<leader>xx",
                function()
                    toggle({ mode = "diagnostics" })
                end,
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                function()
                    toggle({
                        mode = "diagnostics",
                        filter = { buf = 0 },
                    })
                end,
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                function()
                    toggle({ mode = "symbols", focus = false })
                end,
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                function()
                    toggle({
                        mode = "lsp",
                        focus = false,
                        win = {
                            position = "right",
                        },
                    })
                end,
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                function()
                    toggle({ mode = "loclist" })
                end,
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                function()
                    toggle({ mode = "qflist" })
                end,
                desc = "Quickfix List (Trouble)",
            },
        }
    end,
    opts = {},
}
