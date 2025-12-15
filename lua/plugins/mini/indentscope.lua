return {
  "nvim-mini/mini.indentscope",
  event = "VeryLazy",
  init = function()
    local filter = {
      filetype = { "lspinfo", "packer", "checkhealth", "help", "man", "gitcommit", "dashboard", "" },
      buftype = { "terminal", "quickfix", "nofile", "prompt" },
    }
    vim.api.nvim_create_autocmd("BufWinEnter", {
      callback = function(args)
        local bufnr = args.buf

        local ft = vim.api.nvim_get_option_value("ft", { buf = bufnr })
        local bt = vim.api.nvim_get_option_value("bt", { buf = bufnr })

        vim.api.nvim_buf_set_var(
          bufnr,
          "miniindentscope_disable",
          vim.tbl_contains(filter.filetype, ft) or vim.tbl_contains(filter.buftype, bt)
        )
      end,
    })
  end,
  opts = {
    options = { try_as_border = true },
    symbol = "▏",
  },
}
