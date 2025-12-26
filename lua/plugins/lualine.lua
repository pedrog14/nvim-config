return {
  "nvim-lualine/lualine.nvim",
  dependencies = "nvim-mini/mini.icons",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.api.nvim_set_option_value("statusline", " ", {})
    else
      -- hide the statusline on the starter page
      vim.api.nvim_set_option_value("laststatus", 0, {})
    end
  end,
  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local snacks_picker = {
      sections = {
        lualine_a = {
          function()
            return "Snacks.picker"
          end,
        },
      },
      filetypes = {
        "snacks_picker_input",
        "snacks_picker_list",
        "snacks_picker_preview",
      },
    }

    local signs = require("utils.icons").diagnostic.signs
    local breadcrumbs = require("utils.lsp.breadcrumbs")

    breadcrumbs.setup()

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            symbols = {
              error = signs[1],
              warn = signs[2],
              info = signs[3],
              hint = signs[4],
            },
          },
        },
        lualine_c = { "filename", breadcrumbs.get },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype",
          {
            "lsp_status",
            icon = "",
            symbols = { done = "" },
            ignore_lsp = { "stylua" },
          },
        },
      },
      extensions = {
        "lazy",
        "mason",
        "quickfix",
        snacks_picker,
      },
    }
  end,
}
