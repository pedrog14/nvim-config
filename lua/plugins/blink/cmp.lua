return {
  "saghen/blink.cmp",
  dependencies = { "nvim-mini/mini.icons", "rafamadriz/friendly-snippets" },
  build = "cargo build --release",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = function()
    local symbols = require("utils.icons").lsp.symbols

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    return {
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          window = { winblend = vim.o.winblend },
        },
        list = { selection = { preselect = false } },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
            components = {
              kind_icon = {
                text = function(ctx)
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
    }
  end,
}
