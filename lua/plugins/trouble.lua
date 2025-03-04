return {
    "folke/trouble.nvim",
    dependencies = "echasnovski/mini.icons",
    cmd = "Trouble",
    keys = { --[[@diagnostic disable: missing-fields]]
        {
            "<leader>xx",
            function()
                require("trouble").toggle({ mode = "diagnostics" })
            end,
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            function()
                require("trouble").toggle({
                    mode = "diagnostics",
                    filter = { buf = 0 },
                })
            end,
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>cs",
            function()
                require("trouble").toggle({ mode = "symbols", focus = false })
            end,
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>cl",
            function()
                require("trouble").toggle({
                    mode = "lsp",
                    focus = false,
                    win = { position = "right" },
                })
            end,
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xL",
            function()
                require("trouble").toggle({ mode = "loclist" })
            end,
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xQ",
            function()
                require("trouble").toggle({ mode = "qflist" })
            end,
            desc = "Quickfix List (Trouble)",
        },
    },
    opts = {},
}
