----------------------
-- 󰌌 Neovim keymaps --
----------------------

-- Better Up/Down (for wrapped text)
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Better search
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Previous Search Result" })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous Search Result" })

-- Better Buffer control
vim.keymap.set("n", "<a-h>", "<cmd>bprev<cr>", { desc = "Go to Previous Buffer" })
vim.keymap.set("n", "<a-l>", "<cmd>bnext<cr>", { desc = "Go to Next Buffer" })

-- -- Better Window control
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Go to Right Window", remap = true })

vim.keymap.set("n", "<a-X>", "<cmd>bdel<cr>", { desc = "Delete Buffer + Window" })

-- Lazy
vim.keymap.set("n", "<leader>l", function()
    require("lazy").show()
end, { desc = "Open Lazy" })

-- LSP related keymaps
do
    local buf = vim.lsp.buf
    local codelens = vim.lsp.codelens

    vim.keymap.set("n", "E", function()
        vim.diagnostic.open_float()
    end, {
        desc = "Show diagnostics in a floating window",
    })
    vim.keymap.set("n", "K", function()
        buf.hover()
    end, {
        desc = "Displays hover information about the symbol under the cursor in a floating window",
    })
    vim.keymap.set({ "n", "i" }, "<c-s>", function()
        buf.signature_help()
    end, {
        desc = "Displays signature information about the symbol under the cursor in a floating window",
    })
    vim.keymap.set("n", "grn", function()
        buf.rename()
    end, {
        desc = "Renames all references to the symbol under the cursor",
    })
    vim.keymap.set({ "n", "x" }, "gra", function()
        buf.code_action()
    end, {
        desc = "Selects a code action available at the current cursor position",
    })
    vim.keymap.set({ "n", "v" }, "grc", function()
        codelens.run()
    end, {
        desc = "Run the code lens in the current line",
    })
    vim.keymap.set("n", "grC", function()
        codelens.refresh()
    end, {
        desc = "Refresh the lenses",
    })
end
