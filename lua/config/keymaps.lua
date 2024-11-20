----------------------
-- 󰌌 Neovim keymaps --
----------------------

local keymap_set = vim.keymap.set

---@type vim.keymap.set.Opts
local keymap_opts = { noremap = true, silent = true }

keymap_set("n", "n", "nzzzv", keymap_opts)
keymap_set("n", "N", "Nzzzv", keymap_opts)
keymap_set("n", "<c-d>", "<c-d>zz", keymap_opts)
keymap_set("n", "<c-u>", "<c-u>zz", keymap_opts)

keymap_set("n", "<c-h>", "<c-w>h", keymap_opts)
keymap_set("n", "<c-j>", "<c-w>j", keymap_opts)
keymap_set("n", "<c-k>", "<c-w>k", keymap_opts)
keymap_set("n", "<c-l>", "<c-w>l", keymap_opts)

keymap_set("n", "<a-X>", "<cmd>bdelete!<cr>", keymap_opts)

keymap_set("t", "<esc>", "<c-\\><c-n>", keymap_opts)
