----------------------
--  Neovim options --
----------------------

local g = vim.g

g.mapleader = " "
g.maplocalleader = "\\"

local opt = vim.opt

opt.autoindent = true
opt.bg = "dark"
opt.completeopt =
    vim.tbl_extend("keep", { "menu", "menuone", "noselect" }, vim.fn.has("nvim-0.11.0") == 1 and { "fuzzy" } or {})
opt.cursorline = true
opt.expandtab = true
opt.formatexpr = "v:lua.require('conform').formatexpr()"
opt.hlsearch = false
opt.incsearch = true
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.shiftwidth = 4
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartindent = true
opt.smoothscroll = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 4
opt.undofile = true
opt.updatetime = 200
opt.wrap = false
