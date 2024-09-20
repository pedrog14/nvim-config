----------------------
-- 󰌌 Neovim keymaps --
----------------------

-- Mapleader => <space>
vim.g.mapleader = require("config").mapleader
vim.g.maplocalleader = require("config").maplocalleader

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<c-d>", "<c-d>zz", opts)
keymap.set("n", "<c-u>", "<c-u>zz", opts)

keymap.set("n", "<c-h>", "<c-w>h", opts)
keymap.set("n", "<c-j>", "<c-w>j", opts)
keymap.set("n", "<c-k>", "<c-w>k", opts)
keymap.set("n", "<c-l>", "<c-w>l", opts)

keymap.set("v", ">", ">gv", opts)
keymap.set("v", "<", "<gv", opts)

keymap.set("t", "<esc>", "<c-\\><c-n>", opts)

-- LSP related keymaps
local diagnostic = vim.diagnostic
local lspbuf = vim.lsp.buf

keymap.set("n", "<leader>cd", diagnostic.open_float, {
    desc = "Show diagnostics in a floating window",
})
keymap.set("n", "<leader>dk", diagnostic.goto_prev, {
    desc = "Move to the previous diagnostic in the current buffer",
})
keymap.set("n", "<leader>dj", diagnostic.goto_next, {
    desc = "Move to the next diagnostic in the current buffer",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local buf_opts = { buffer = event.buf }
        local builtin = require("telescope.builtin")
        keymap.set(
            "n",
            "K",
            lspbuf.hover,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Displays hover information about the symbol under the cursor in a floating window",
            })
        )
        keymap.set(
            "n",
            "gD",
            lspbuf.declaration,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Jumps to the declaration of the symbol under the cursor",
            })
        )
        keymap.set(
            "n",
            "gd",
            builtin.lsp_definitions,
            vim.tbl_extend("keep", buf_opts, {
                desc =
                "Go to the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope",
            })
        )
        keymap.set(
            "n",
            "gI",
            builtin.lsp_implementations,
            vim.tbl_extend("keep", buf_opts, {
                desc =
                "Go to the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope",
            })
        )
        keymap.set(
            "n",
            "gr",
            builtin.lsp_references,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Lists LSP references for word under the cursor, jumps to reference on <cr>",
            })
        )
        keymap.set(
            "n",
            "gy",
            builtin.lsp_type_definitions,
            vim.tbl_extend("keep", buf_opts, {
                desc =
                "Go to the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope",
            })
        )
        keymap.set(
            "n",
            "gK",
            lspbuf.signature_help,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Displays signature information about the symbol under the cursor in a floating window",
            })
        )
        keymap.set(
            "i",
            "<c-k>",
            lspbuf.signature_help,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Displays signature information about the symbol under the cursor in a floating window",
            })
        )

        keymap.set(
            "n",
            "<leader>cr",
            lspbuf.rename,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Renames all references to the symbol under the cursor",
            })
        )
        keymap.set(
            { "n", "v" },
            "<leader>ca",
            lspbuf.code_action,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Selects a code action available at the current cursor position",
            })
        )
        keymap.set(
            { "n", "v" },
            "<leader>cc",
            vim.lsp.codelens.run,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Run the code lens in the current line",
            })
        )
        keymap.set(
            "n",
            "<leader>cc",
            vim.lsp.codelens.refresh,
            vim.tbl_extend("keep", buf_opts, {
                desc = "Refresh the lenses",
            })
        )
    end,
})
