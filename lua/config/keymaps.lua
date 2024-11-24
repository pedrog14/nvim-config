----------------------
-- 󰌌 Neovim keymaps --
----------------------

local keymap_set = vim.keymap.set

keymap_set("n", "n", "nzzzv", { noremap = true })
keymap_set("n", "N", "Nzzzv", { noremap = true })
keymap_set("n", "<c-d>", "<c-d>zz", { noremap = true })
keymap_set("n", "<c-u>", "<c-u>zz", { noremap = true })

keymap_set("n", "<c-h>", "<c-w>h", { noremap = true })
keymap_set("n", "<c-j>", "<c-w>j", { noremap = true })
keymap_set("n", "<c-k>", "<c-w>k", { noremap = true })
keymap_set("n", "<c-l>", "<c-w>l", { noremap = true })

keymap_set("t", "<esc>", "<c-\\><c-n>", { noremap = true })

keymap_set("n", "<a-X>", "<cmd>bdelete!<cr>", { desc = "Delete Buffer", silent = true })

keymap_set("n", "<leader>l", require("lazy").show, { desc = "Open Lazy" })
