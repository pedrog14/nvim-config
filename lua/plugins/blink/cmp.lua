return {
  "saghen/blink.cmp",
  dependencies = { "saghen/blink.lib", "rafamadriz/friendly-snippets" },
  build = function()
    require("blink.cmp").build():pwait()
  end,
  event = { "InsertEnter", "CmdlineEnter" },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        window = { winblend = vim.o.winblend },
      },
      list = { selection = { preselect = false } },
      menu = {
        draw = {
          padding = 1,
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local symbols = require("utils.icons").lsp.symbols
                return symbols[ctx.kind]
              end,
            },
          },
        },
        max_height = vim.o.pumheight,
        winblend = vim.o.pumblend,
      },
    },
    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        ["<tab>"] = { "select_next", "show" },
        ["<s-tab>"] = { "select_prev", "show" },
      },
      completion = { list = { selection = { preselect = false } } },
    },
    sources = {
      providers = {
        path = { opts = { show_hidden_files_by_default = true } },
      },
    },
  },
}
