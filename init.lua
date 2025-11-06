-- [ NeoVim Settings ] --
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
        ignorecase = true,
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

require("core.lazy").set({
    spec = { { import = "plugins" } },
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
    { "<s-l>", "<cmd>bnext<cr>", { desc = "Go to Next Buffer" } },

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

    -- LSP
    {
        "gra",
        function()
            vim.lsp.buf.code_action()
        end,
        mode = { "n", "x" },
        desc = "Selects a code action available at the cursor position",
        lsp = { method = vim.lsp.protocol.Methods.textDocument_codeAction },
    },
    {
        "grn",
        function()
            vim.lsp.buf.rename()
        end,
        desc = "Renames all references to the symbol under the cursor",
        lsp = { method = vim.lsp.protocol.Methods.textDocument_rename },
    },
    {
        "<c-s>",
        function()
            vim.lsp.buf.signature_help()
        end,
        mode = "i",
        desc = "Displays signature information about the symbol under the cursor",
        lsp = { method = vim.lsp.protocol.Methods.textDocument_signatureHelp },
    },
    {
        "K",
        function()
            vim.lsp.buf.hover()
        end,
        desc = "Displays hover information about the symbol under the cursor",
        lsp = { method = vim.lsp.protocol.Methods.textDocument_hover },
    },
})

require("core.autocmds").set({
    {
        event = "TextYankPost",
        callback = function()
            (vim.hl or vim.highlight).on_yank()
        end,
    },
})
