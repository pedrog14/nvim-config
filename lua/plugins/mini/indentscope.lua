return {
  "nvim-mini/mini.indentscope",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
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
        local bufnr = vim._resolve_bufnr(args.buf)
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        vim.api.nvim_buf_set_var(
          bufnr,
          "miniindentscope_disable",
          vim.tbl_contains(filter.filetype, vim.api.nvim_get_option_value("ft", { buf = bufnr }))
            or vim.tbl_contains(filter.buftype, vim.api.nvim_get_option_value("bt", { buf = bufnr }))
        )
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksDashboardOpened",
      callback = function(args)
        local bufnr = vim._resolve_bufnr(args.buf)
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        vim.api.nvim_buf_set_var(bufnr, "miniindentscope_disable", true)
      end,
    })
  end,
  opts = {
    options = { try_as_border = true },
    symbol = "▏",
  },
}
