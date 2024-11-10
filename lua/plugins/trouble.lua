return {
    "folke/trouble.nvim",
    dependencies = "echasnovski/mini.icons",
    cmd = "Trouble",
    keys = {
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
                require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
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
            "<leader>cS",
            function()
                require("trouble").toggle({ mode = "lsp", focus = false, win = { position = "right" } })
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
        {
            "[q",
            function()
                if require("trouble").is_open() then
                    require("trouble").prev({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cprev)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Previous Trouble/Quickfix Item",
        },
        {
            "]q",
            function()
                if require("trouble").is_open() then
                    require("trouble").next({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cnext)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Next Trouble/Quickfix Item",
        },
    },
    opts = {},
}
