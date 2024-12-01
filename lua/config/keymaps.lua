----------------------
-- 󰌌 Neovim keymaps --
----------------------

local keymap_set = vim.keymap.set

-- Better <C-d> <C-u>
keymap_set("n", "<c-d>", "<c-d>zz", { noremap = true })
keymap_set("n", "<c-u>", "<c-u>zz", { noremap = true })

-- Better search
keymap_set(
    "n",
    "n",
    "'Nn'[v:searchforward].'zzzv'",
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
    "'nN'[v:searchforward].'zzzv'",
    { expr = true, desc = "Previous Search Result" }
)
keymap_set(
    { "x", "o" },
    "N",
    "'nN'[v:searchforward]",
    { expr = true, desc = "Previous Search Result" }
)

-- Better Buffer control
keymap_set("n", "<a-h>", "<cmd>bprev<cr>", { desc = "Go to Previous Buffer" })
keymap_set("n", "<a-l>", "<cmd>bnext<cr>", { desc = "Go to Next Buffer" })

-- Better Window control
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

-- Splits
keymap_set("n", "<a-s>", "<c-w>s", { desc = "Split Window (Horizontal)" })
keymap_set("n", "<a-v>", "<c-w>v", { desc = "Split Window (Vertical)" })

-- Delete Buffer/Window
keymap_set("n", "<a-x>", function()
    Snacks.bufdelete()
end, { desc = "Delete Buffer" })
keymap_set("n", "<a-c>", "<c-w>c", { desc = "Delete Window" })
keymap_set("n", "<a-X>", "<cmd>bdel<cr>", { desc = "Delete Buffer + Window" })

-- Better Terminal <Esc>
keymap_set("t", "<esc>", "<c-\\><c-n>", { noremap = true })

-- Lazy
keymap_set("n", "<leader>l", function()
    require("lazy").show()
end, { desc = "Open Lazy" })
