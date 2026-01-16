-- [[ Neovim Settings ]] --
local icons = require("utils.icons")

require("core.options").set({
  g = {
    mapleader = " ",
    maplocalleader = "\\",
  },
  o = {
    completeopt = "fuzzy,menuone,noselect,popup",
    confirm = true,
    cursorline = true,
    expandtab = true,
    fillchars = ("foldopen:%s,foldclose:%s"):format(icons.fold.open, icons.fold.close),
    foldlevel = 99,
    foldmethod = "indent",
    foldtext = "",
    hlsearch = false,
    laststatus = 3,
    linebreak = true,
    list = true,
    mouse = "a",
    number = true,
    pumheight = 12,
    relativenumber = true,
    ruler = false,
    scrolloff = 4,
    shiftround = true,
    shiftwidth = 2,
    shortmess = vim.o.shortmess .. "cIW",
    showmode = false,
    sidescrolloff = 8,
    signcolumn = "yes",
    smartindent = true,
    smoothscroll = true,
    softtabstop = 2,
    splitbelow = true,
    splitkeep = "screen",
    splitright = true,
    tabstop = 2,
    termguicolors = true,
    timeoutlen = 300,
    undofile = true,
    updatetime = 200,
    virtualedit = "block",
    wildmode = "full,longest:full,noselect",
    wildoptions = "fuzzy,pum,tagfile",
    wrap = false,
  },
})

require("core.lazy").set({
  spec = {
    { import = "plugins" },
    { import = "plugins.blink" },
    { import = "plugins.colorschemes" },
    { import = "plugins.mini" },
    { import = "plugins.treesitter" },
  },
  checker = { enabled = true },
  ui = {
    backdrop = 100,
    icons = {
      loaded = "●",
      not_loaded = "○",
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

require("core.commands").set({ colorscheme = "gruvbox" })

require("core.keymaps").set({
  -- Better Up/Down (for wrapped text)
  {
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    mode = { "n", "x" },
    desc = "Down",
    expr = true,
    silent = true,
  },
  {
    "<Down>",
    "v:count == 0 ? 'gj' : 'j'",
    mode = { "n", "x" },
    desc = "Down",
    expr = true,
    silent = true,
  },
  {
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    mode = { "n", "x" },
    desc = "Up",
    expr = true,
    silent = true,
  },
  {
    "<Up>",
    "v:count == 0 ? 'gk' : 'k'",
    mode = { "n", "x" },
    desc = "Up",
    expr = true,
    silent = true,
  },

  -- Better search
  {
    "n",
    "'Nn'[v:searchforward].'zv'",
    expr = true,
    desc = "Next Search Result",
  },
  {
    "n",
    "'Nn'[v:searchforward]",
    mode = { "x", "o" },
    expr = true,
    desc = "Next Search Result",
  },
  {
    "N",
    "'nN'[v:searchforward].'zv'",
    expr = true,
    desc = "Previous Search Result",
  },
  {
    "N",
    "'nN'[v:searchforward]",
    mode = { "x", "o" },
    expr = true,
    desc = "Previous Search Result",
  },

  -- Better Buffer control
  { "<s-h>", "<cmd>bprev<cr>", desc = "Go to Previous Buffer" },
  { "<s-l>", "<cmd>bnext<cr>", desc = "Go to Next Buffer" },

  -- Better Window control
  { "<c-h>", "<c-w>h", desc = "Go to Left Window" },
  { "<c-j>", "<c-w>j", desc = "Go to Lower Window" },
  { "<c-k>", "<c-w>k", desc = "Go to Upper Window" },
  { "<c-l>", "<c-w>l", desc = "Go to Right Window" },

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

  -- Snippets
  {
    "<c-h>",
    function()
      if vim.snippet.active({ direction = -1 }) then
        return "<cmd>lua vim.snippet.jump(-1)<cr>"
      else
        return "<c-h>"
      end
    end,
    mode = { "i", "s" },
    expr = true,
    silent = true,
  },
  {
    "<c-l>",
    function()
      if vim.snippet.active({ direction = 1 }) then
        return "<cmd>lua vim.snippet.jump(1)<cr>"
      else
        return "<c-l>"
      end
    end,
    mode = { "i", "s" },
    expr = true,
    silent = true,
  },
  {
    "<c-e>",
    function()
      if vim.snippet.active() then
        return "<cmd>lua vim.snippet.stop()<cr>"
      else
        return "<c-e>"
      end
    end,
    mode = { "i", "s" },
    expr = true,
    silent = true,
  },
  -- Stop active snippet before exiting Insert mode
  {
    "<esc>",
    function()
      if vim.snippet.active() then
        vim.snippet.stop()
      end
      return "<esc>"
    end,
    mode = { "i", "s" },
    expr = true,
    silent = true,
  },
})

require("core.autocmds").set({
  {
    event = "UIEnter",
    callback = function()
      vim.o.clipboard = "unnamedplus"
    end,
  },
  {
    event = "TextYankPost",
    callback = function()
      vim.hl.on_yank()
    end,
  },
})
