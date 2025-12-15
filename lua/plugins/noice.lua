return {
  "folke/noice.nvim",
  event = "VeryLazy",
  ---@module "noice"
  ---@type NoiceConfig
  opts = {
    cmdline = {
      format = {
        cmdline = { icon = "" },
        search_up = { icon = " " },
        search_down = { icon = " " },
        input = { icon = "" },
      },
    },
    lsp = {
      progress = { enabled = false },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
    views = {
      confirm = {
        win_options = {
          winhighlight = { FloatTitle = "NoiceCmdlinePopupTitle" },
        },
      },
    },
  },
}
