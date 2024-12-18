return {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    cmd = "Telescope",
    keys = {
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files()
            end,
            desc = "Telescope Find Files",
        },
        {
            "<leader>fg",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Telescope Live Grep",
        },
        {
            "<leader>fb",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "Telescope Buffers",
        },
        {
            "<leader>fh",
            function()
                require("telescope.builtin").help_tags()
            end,
            desc = "Telescope Help Tags",
        },
        {
            "<leader>fo",
            function()
                require("telescope.builtin").oldfiles()
            end,
            desc = "Telescope Oldfiles",
        },
        {
            "<leader>fc",
            function()
                require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Telescope Config Files",
        },

        -- LSP related keymaps
        {
            "gO",
            function()
                require("telescope.builtin").lsp_document_symbols()
            end,
            desc = "List all symbols in the current buffer in Telescope",
        },
        {
            "grr",
            function()
                require("telescope.builtin").lsp_references()
            end,
            desc = "Lists all the references to the symbol under the cursor in Telescope",
        },
        {
            "gri",
            function()
                require("telescope.builtin").lsp_implementations()
            end,
            desc = "Jumps to the implementation of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
        },
        {
            "grd",
            function()
                require("telescope.builtin").lsp_definitions()
            end,
            desc = "Jumps to the definition of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
        },
        {
            "grt",
            function()
                require("telescope.builtin").lsp_type_definitions()
            end,
            desc = "Jumps to the definition of the type of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
        },
    },
    main = "utils.plugins.telescope",
    opts = {
        defaults = {
            prompt_prefix = "󰁔 ",
            selection_caret = "󰁔 ",
        },
        pickers = {
            find_files = {
                follow = true,
                hidden = true,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            },
        },
    },
}
