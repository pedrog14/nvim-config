return {
  "saghen/blink.cmp",
  dependencies = { "nvim-mini/mini.icons", "nvim-mini/mini.snippets" },
  version = "*",
  event = { "InsertEnter", "CmdlineEnter" },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    snippets = { preset = "mini_snippets" },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
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
                local kind_icon, _, _ = MiniIcons.get("lsp", ctx.kind)
                return kind_icon
              end,
            },
          },
        },
        max_height = vim.api.nvim_get_option_value("pumheight", {}),
      },
    },
    keymap = {
      preset = "default",
      ["<c-n>"] = { "select_next", "show", "fallback_to_mappings" },
    },
    cmdline = {
      keymap = {
        preset = "cmdline",
        ["<c-n>"] = { "select_next", "show", "fallback" },
        ["<c-p>"] = { "select_prev", "fallback" },

        ["<tab>"] = { "select_next", "show" },
        ["<s-tab>"] = { "select_prev", "show" },
      },
      completion = { list = { selection = { preselect = false } } },
    },
  },
}
