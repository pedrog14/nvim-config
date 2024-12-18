----------------------
-- 󰌌 Neovim keymaps --
----------------------

local keymap_set = vim.keymap.set

-- Better <C-d> <C-u>
keymap_set("n", "<c-d>", "<c-d>zz", { noremap = true })
keymap_set("n", "<c-u>", "<c-u>zz", { noremap = true })

-- Better search
keymap_set("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })
keymap_set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap_set("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Previous Search Result" })
keymap_set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous Search Result" })

-- Better Buffer control
keymap_set("n", "<a-h>", "<cmd>bprev<cr>", { desc = "Go to Previous Buffer" })
keymap_set("n", "<a-l>", "<cmd>bnext<cr>", { desc = "Go to Next Buffer" })

-- Better Window control
keymap_set("n", "<c-h>", "<c-w>h", { desc = "Go to Left Window", remap = true })
keymap_set("n", "<c-j>", "<c-w>j", { desc = "Go to Lower Window", remap = true })
keymap_set("n", "<c-k>", "<c-w>k", { desc = "Go to Upper Window", remap = true })
keymap_set("n", "<c-l>", "<c-w>l", { desc = "Go to Right Window", remap = true })

-- Splits
keymap_set("n", "<a-s>", "<c-w>s", { desc = "Split Window (Horizontal)" })
keymap_set("n", "<a-v>", "<c-w>v", { desc = "Split Window (Vertical)" })

-- Delete Buffer/Window
keymap_set("n", "<a-c>", "<cmd>quit<cr>", { desc = "Delete Window" })
keymap_set("n", "<a-X>", "<cmd>bdel<cr>", { desc = "Delete Buffer + Window" })

-- Better Terminal control
keymap_set("t", "<esc>", "<c-\\><c-n>", { noremap = true })
keymap_set("n", "<c-/>", function()
    Snacks.terminal.toggle()
end, { desc = "Toggle Terminal" })

-- Lazy
keymap_set("n", "<leader>l", function()
    require("lazy").show()
end, { desc = "Open Lazy" })

-- LSP related keymaps
do
    local buf = vim.lsp.buf
    local codelens = vim.lsp.codelens

    keymap_set("n", "K", function()
        buf.hover()
    end, {
        desc = "Displays hover information about the symbol under the cursor in a floating window",
    })
    keymap_set({ "n", "i" }, "<c-s>", function()
        buf.signature_help()
    end, {
        desc = "Displays signature information about the symbol under the cursor in a floating window",
    })
    keymap_set("n", "grn", function()
        buf.rename()
    end, {
        desc = "Renames all references to the symbol under the cursor",
    })
    keymap_set({ "n", "x" }, "gra", function()
        buf.code_action()
    end, {
        desc = "Selects a code action available at the current cursor position",
    })
    keymap_set({ "n", "v" }, "grc", function()
        codelens.run()
    end, {
        desc = "Run the code lens in the current line",
    })
    keymap_set("n", "grC", function()
        codelens.refresh()
    end, {
        desc = "Refresh the lenses",
    })
end

-- Snacks
keymap_set("n", "<a-x>", function()
    Snacks.bufdelete()
end, { desc = "Delete Buffer" })

keymap_set({ "n", "t" }, "[[", function()
    Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous Reference" })
keymap_set({ "n", "t" }, "]]", function()
    Snacks.words.jump(vim.v.count1)
end, { desc = "Next Reference" })

keymap_set("n", "grN", function()
    Snacks.rename.rename_file()
end, { desc = "Rename file" })
