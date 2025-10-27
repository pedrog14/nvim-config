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
        formatexpr = "v:lua.require('conform').formatexpr()",
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
    { { "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true } },
    { { "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true } },
    { { "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true } },
    { { "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true } },

    -- Better search
    { "n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" } },
    { { "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" } },
    { "n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Previous Search Result" } },
    { { "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous Search Result" } },

    -- Better Buffer control
    { "n", "<s-h>", "<cmd>bprev<cr>", { desc = "Go to Previous Buffer" } },
    { "n", "<s-l>", "<cmd>bnext<cr>", { desc = "Go to Next Buffer" } },

    -- Better Window control
    { "n", "<c-h>", "<c-w>h", { desc = "Go to Left Window", remap = true } },
    { "n", "<c-j>", "<c-w>j", { desc = "Go to Lower Window", remap = true } },
    { "n", "<c-k>", "<c-w>k", { desc = "Go to Upper Window", remap = true } },
    { "n", "<c-l>", "<c-w>l", { desc = "Go to Right Window", remap = true } },
    { "n", "<c-w>X", "<cmd>bdel<cr>", { desc = "Delete Buffer + Window" } },

    -- Lazy
    {
        "n",
        "<leader>l",
        function()
            require("lazy").show()
        end,
        { desc = "Open Lazy" },
    },

    -- LSP
    {
        "n",
        "E",
        function()
            vim.diagnostic.open_float()
        end,
        {
            desc = "Show diagnostics in a floating window",
            lsp = { method = vim.lsp.protocol.Methods.textDocument_diagnostic },
        },
    },
    {
        "n",
        "K",
        function()
            vim.lsp.buf.hover()
        end,
        {
            desc = "Displays hover information about the symbol under the cursor in a floating window",
            lsp = { method = vim.lsp.protocol.Methods.textDocument_hover },
        },
    },
    {
        { "n", "i" },
        "<c-s>",
        function()
            vim.lsp.buf.signature_help()
        end,
        {
            desc = "Displays signature information about the symbol under the cursor in a floating window",
            lsp = { method = vim.lsp.protocol.Methods.textDocument_signatureHelp },
        },
    },
    {
        "n",
        "grn",
        function()
            vim.lsp.buf.rename()
        end,
        {
            desc = "Renames all references to the symbol under the cursor",
            lsp = { method = vim.lsp.protocol.Methods.textDocument_rename },
        },
    },
    {
        { "n", "x" },
        "gra",
        function()
            vim.lsp.buf.code_action()
        end,
        {
            desc = "Selects a code action available at the current cursor position",
            lsp = { method = vim.lsp.protocol.Methods.textDocument_codeAction },
        },
    },
    {
        { "n", "v" },
        "grc",
        function()
            vim.lsp.codelens.run()
        end,
        {
            desc = "Run the code lens in the current line",
            lsp = { method = vim.lsp.protocol.Methods.textDocument_codeLens },
        },
    },
    {
        "n",
        "grC",
        function()
            vim.lsp.codelens.refresh()
        end,
        {
            desc = "Refresh the lenses",
            lsp = { method = vim.lsp.protocol.Methods.textDocument_codeLens },
        },
    },
})
