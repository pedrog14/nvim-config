return {
  "saghen/blink.cmp",
  dependencies = { "nvim-mini/mini.icons", "rafamadriz/friendly-snippets" },
  build = "cargo build --release",
  event = { "InsertEnter", "CmdlineEnter" },
  ---@module "blink.cmp"
  ---@param _opts blink.cmp.Config
  opts = function(_, _opts)
    local symbols = require("utils.icons").lsp.symbols

    ---@type blink.cmp.Config
    local opts = {
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

    return vim.tbl_deep_extend("force", _opts, opts)
  end,
}
