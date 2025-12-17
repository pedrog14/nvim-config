return {
  "nvim-mini/mini.indentscope",
  event = "VeryLazy",
  init = function()
    local filter = {
      filetype = {
        "lspinfo",
        "packer",
        "checkhealth",
        "help",
        "man",
        "gitcommit",
        "dashboard",
        "text",
        "",
      },
      buftype = { "terminal", "quickfix", "nofile", "prompt" },
    }
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        vim.api.nvim_buf_set_var(
          args.buf,
          "miniindentscope_disable",
          vim.tbl_contains(filter.filetype, vim.api.nvim_get_option_value("ft", { buf = args.buf }))
            or vim.tbl_contains(filter.buftype, vim.api.nvim_get_option_value("bt", { buf = args.buf }))
        )
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksDashboardOpened",
      callback = function(args)
        vim.api.nvim_buf_set_var(args.buf, "miniindentscope_disable", true)
      end,
    })
  end,
  opts = {
    options = { try_as_border = true },
    symbol = "▏",
  },
}
