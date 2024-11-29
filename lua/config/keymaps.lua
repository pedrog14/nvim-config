----------------------
-- 󰌌 Neovim keymaps --
----------------------

local keymap_set = vim.keymap.set

-- Better Up Down
keymap_set(
    { "n", "x" },
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { desc = "Down", expr = true, silent = true }
)
keymap_set(
    { "n", "x" },
    "<Down>",
    "v:count == 0 ? 'gj' : 'j'",
    { desc = "Down", expr = true, silent = true }
)
keymap_set(
    { "n", "x" },
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { desc = "Up", expr = true, silent = true }
)
keymap_set(
    { "n", "x" },
    "<Up>",
    "v:count == 0 ? 'gk' : 'k'",
    { desc = "Up", expr = true, silent = true }
)

-- Better <C-d> <C-u>
keymap_set("n", "<c-d>", "<c-d>zz", { noremap = true })
keymap_set("n", "<c-u>", "<c-u>zz", { noremap = true })

-- Better search
keymap_set("n", "n", "nzzzv", { noremap = true })
keymap_set("n", "N", "Nzzzv", { noremap = true })

keymap_set("t", "<esc>", "<c-\\><c-n>", { noremap = true })

-- Better buffer control (Check snacks.nvim keys)
keymap_set("n", "<a-h>", "<cmd>bprev<cr>")
keymap_set("n", "<a-l>", "<cmd>bnext<cr>")

keymap_set(
    "n",
    "n",
    "'Nn'[v:searchforward].'zv'",
    { expr = true, desc = "Next Search Result" }
)
keymap_set(
    { "x", "o" },
    "n",
    "'Nn'[v:searchforward]",
    { expr = true, desc = "Next Search Result" }
)

keymap_set(
    "n",
    "N",
    "'nN'[v:searchforward].'zv'",
    { expr = true, desc = "Prev Search Result" }
)
keymap_set(
    { "x", "o" },
    "N",
    "'nN'[v:searchforward]",
    { expr = true, desc = "Prev Search Result" }
)

-- Better window control
keymap_set("n", "<c-h>", "<c-w>h", { desc = "Go to Left Window", remap = true })
keymap_set(
    "n",
    "<c-j>",
    "<c-w>j",
    { desc = "Go to Lower Window", remap = true }
)
keymap_set(
    "n",
    "<c-k>",
    "<c-w>k",
    { desc = "Go to Upper Window", remap = true }
)
keymap_set(
    "n",
    "<c-l>",
    "<c-w>l",
    { desc = "Go to Right Window", remap = true }
)
keymap_set("n", "<a-s>", "<c-w>s", { desc = "Split Window (Horizontal)" })
keymap_set("n", "<a-v>", "<c-w>v", { desc = "Split Window (Vertical)" })
keymap_set("n", "<a-c>", "<c-w>c", { desc = "Delete Window" })
keymap_set(
    "n",
    "<a-X>",
    "<cmd>bdelete!<cr>",
    { desc = "Delete Window + Buffer" }
)

keymap_set("n", "<leader>l", require("lazy").show, { desc = "Open Lazy" })
