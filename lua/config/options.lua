----------------------
--  Neovim options --
----------------------

local g = vim.g

g.mapleader = " "
g.maplocalleader = "\\"

local opt = vim.opt

opt.autoindent = true
opt.bg = "dark"
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.completeopt = { "menuone", "noselect", "fuzzy", "popup" }
opt.cursorline = true
opt.expandtab = true
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldtext = ""
opt.formatexpr = "v:lua.require('conform').formatexpr()"
opt.hlsearch = false
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 3
opt.list = true
opt.number = true
opt.pumheight = 12
opt.relativenumber = true
opt.ruler = false
opt.scrolloff = 4
opt.shiftround = true
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
opt.timeoutlen = 500
opt.undofile = true
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = { "longest:full", "full" }
opt.wildoptions = { "fuzzy", "pum", "tagfile" }
opt.wrap = false
