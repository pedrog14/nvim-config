return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
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
    },
    main = "utils.plugins.telescope",
    opts = {
        defaults = {
            layout_strategy = "vertical",
            prompt_prefix = "󱞩 ",
            selection_caret = "󰁔 ",
        },
        pickers = {
            find_files = {
                follow = true,
                hidden = true,
            },
            fd = {
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
        -- List of extensions that should be loaded using telescope.load_extension("extension_name")
        load_extensions = { "fzf" },
    },
}
