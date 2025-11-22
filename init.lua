-- [[ NeoVim Settings ]] --
require("core.options").set({
    g = {
        mapleader = " ",
        maplocalleader = "\\",
    },
    o = {
        autoindent = true,
        bg = "dark",
        clipboard = "unnamedplus",
        completeopt = "fuzzy,menuone,noselect,popup",
        confirm = true,
        cursorline = true,
        expandtab = true,
        fillchars = vim.api.nvim_get_option_value("fillchars", {}) .. "foldclose:󰅂",
        foldlevel = 99,
        foldtext = "",
        hlsearch = false,
        incsearch = true,
        laststatus = 3,
        list = true,
        number = true,
        pumheight = 12,
        relativenumber = true,
        ruler = false,
        scrolloff = 4,
        shiftround = true,
        shiftwidth = 4,
        shortmess = vim.api.nvim_get_option_value("shortmess", {}) .. "cCIW",
        showmode = false,
        sidescrolloff = 8,
        signcolumn = "yes",
        smartindent = true,
        smoothscroll = true,
        softtabstop = 4,
        splitbelow = true,
        splitkeep = "screen",
        splitright = true,
        tabstop = 4,
        timeoutlen = 500,
        undofile = true,
        updatetime = 200,
        virtualedit = "block",
        wildmode = "full,longest:full",
        wildoptions = "fuzzy,pum,tagfile",
        wrap = false,
    },
})

require("core.keymaps").del({
    { "gra", mode = { "n", "x" } },
    { "gri" },
    { "grn" },
    { "grr" },
    { "grt" },
    { "gO" },
    { "<c-s>", mode = "i" },
})

require("core.lazy").set({
    spec = {
        { import = "plugins" },
        { import = "plugins.colorschemes" },
        { import = "plugins.blink" },
        { import = "plugins.mini" },
        { import = "plugins.treesitter" },
    },
    install = { colorscheme = { "gruvbox" } },
    checker = { enabled = true },
    ui = {
        backdrop = 100,
        icons = {
            loaded = "󰱒",
            not_loaded = "󰄱",
        },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

require("core.commands").set({
    colorscheme = "gruvbox",
})

require("core.keymaps").set({
    -- Better Up/Down (for wrapped text)
    { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Down", expr = true, silent = true },
    { "<Down>", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Down", expr = true, silent = true },
    { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Up", expr = true, silent = true },
    { "<Up>", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Up", expr = true, silent = true },

    -- Better search
    { "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search Result" },
    { "n", "'Nn'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Next Search Result" },
    { "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Previous Search Result" },
    { "N", "'nN'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Previous Search Result" },

    -- Better Buffer control
    { "<s-h>", "<cmd>bprev<cr>", desc = "Go to Previous Buffer" },
    { "<s-l>", "<cmd>bnext<cr>", desc = "Go to Next Buffer" },

    -- Better Window control
    { "<c-h>", "<c-w>h", desc = "Go to Left Window", remap = true },
    { "<c-j>", "<c-w>j", desc = "Go to Lower Window", remap = true },
    { "<c-k>", "<c-w>k", desc = "Go to Upper Window", remap = true },
    { "<c-l>", "<c-w>l", desc = "Go to Right Window", remap = true },

    { "<c-w>X", "<cmd>bdel<cr>", desc = "Delete Buffer + Window" },

    -- Lazy
    {
        "<leader>l",
        function()
            require("lazy").show()
        end,
        desc = "Open Lazy",
    },

    -- LSP mappings
    {
        "gra",
        function()
            vim.lsp.buf.code_action()
        end,
        mode = { "n", "x" },
        desc = "Selects a code action available at the cursor position",
    },
    {
        "gri",
        function()
            Snacks.picker.lsp_implementations()
        end,
        desc = "Lists all the implementations for the symbol under the cursor (Snacks.picker)",
    },
    {
        "grn",
        function()
            vim.lsp.buf.rename()
        end,
        desc = "Renames all references to the symbol under the cursor",
    },
    {
        "grr",
        function()
            Snacks.picker.lsp_references()
        end,
        desc = "Lists all the references to the symbol under the cursor (Snacks.picker)",
    },
    {
        "grt",
        function()
            Snacks.picker.lsp_type_definitions()
        end,
        desc = "Jumps to the definition of the type of the symbol under the cursor (Snacks.picker)",
    },
    {
        "gO",
        function()
            Snacks.picker.lsp_symbols()
        end,
        desc = "List all symbols in the current buffer (Snacks.picker)",
    },
    {
        "<c-s>",
        function()
            vim.lsp.buf.signature_help()
        end,
        mode = "i",
        desc = "Displays signature information about the symbol under the cursor",
    },
    {
        "grd",
        function()
            Snacks.picker.lsp_definitions()
        end,
        desc = "Lists all the definitions for the symbol under the cursor (Snacks.picker)",
    },
    {
        "grD",
        function()
            Snacks.picker.lsp_declarations()
        end,
        desc = "Lists all the declarations for the symbol under the cursor (Snacks.picker)",
    },
})

require("core.autocmds").set({
    {
        event = "TextYankPost",
        callback = function()
            vim.hl.on_yank()
        end,
    },
})
