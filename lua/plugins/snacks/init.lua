return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    keys = {
        {
            "<leader>sf",
            function()
                Snacks.picker.files()
            end,
            desc = "Find Files (Snacks.picker)",
        },
        {
            "<leader>sg",
            function()
                Snacks.picker.grep()
            end,
            desc = "Live Grep (Snacks.picker)",
        },
        {
            "<leader>sb",
            function()
                Snacks.picker.buffers()
            end,
            desc = "Buffers (Snacks.picker)",
        },
        {
            "<leader>sh",
            function()
                Snacks.picker.help()
            end,
            desc = "Help Pages (Snacks.picker)",
        },
        {
            "<leader>sr",
            function()
                Snacks.picker.recent()
            end,
            desc = "Recent Files (Snacks.picker)",
        },
        {
            "<leader>sc",
            function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Config Files (Snacks.picker)",
        },

        {
            "gO",
            function()
                Snacks.picker.lsp_symbols()
            end,
            desc = "List all symbols in the current buffer (Snacks.picker)",
        },
        {
            "grr",
            function()
                Snacks.picker.lsp_references()
            end,
            desc = "List all symbols in the current buffer (Snacks.picker)",
        },
        {
            "gri",
            function()
                Snacks.picker.lsp_implementations()
            end,
            desc = "Jumps to the implementation of the symbol under the cursor, if there's only one, otherwise show all options (Snacks.picker)",
        },
        {
            "grd",
            function()
                Snacks.picker.lsp_definitions()
            end,
            desc = "Jumps to the definition of the symbol under the cursor, if there's only one, otherwise show all options (Snacks.picker)",
        },
        {
            "grt",
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            desc = "Jumps to the definition of the type of the symbol under the cursor, if there's only one, otherwise show all options (Snacks.picker)",
        },

        {
            "grN",
            function()
                Snacks.rename.rename_file()
            end,
            desc = "Rename File",
        },

        {
            "<a-x>",
            function()
                Snacks.bufdelete()
            end,
            desc = "Delete Buffer",
        },

        {
            "[[",
            function()
                Snacks.words.jump(-vim.v.count1)
            end,
            desc = "Previous Reference",
            mode = { "n", "t" },
        },
        {
            "]]",
            function()
                Snacks.words.jump(vim.v.count1)
            end,
            desc = "Next Reference",
            mode = { "n", "t" },
        },

        {
            "<c-/>",
            function()
                Snacks.terminal.toggle()
            end,
            desc = "Toggle Terminal",
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command
            end,
        })
    end,
    main = "utils.plugins.snacks",
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
}
