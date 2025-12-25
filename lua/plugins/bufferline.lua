return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-mini/mini.icons",
  event = "VeryLazy",
  ---@module "bufferline"
  ---@type bufferline.UserConfig
  opts = {
    options = {
      numbers = function(num)
        return ("%s%s"):format(num.raise(num.id), num.lower(num.ordinal))
      end,
      close_command = function(n)
        Snacks.bufdelete(n)
      end,
      right_mouse_command = function(n)
        Snacks.bufdelete(n)
      end,
      buffer_close_icon = "",
      modified_icon = " ",
      close_icon = " ",
      always_show_bufferline = false,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, errors)
        local indicator = ""
        local signs = require("utils.icons").diagnostic.signs
        local icons = {
          error = signs[1],
          warning = signs[2],
          info = signs[3],
          hint = signs[4],
        }

        for type, number in pairs(errors) do
          local icon = icons[type] or "󰟃 "

          indicator = ("%s%s%s "):format(indicator, icon, number)
        end

        return vim.trim(indicator)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-Tree",
          highlight = "Title",
          text_align = "left",
        },
        { filetype = "snacks_layout_box" },
      },
    },
  },
}
