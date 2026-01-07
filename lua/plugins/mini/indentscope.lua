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
        local bufnr = args.buf

        vim.b[bufnr].miniindentscope_disable = vim.tbl_contains(filter.filetype, vim.bo[bufnr].filetype)
          or vim.tbl_contains(filter.buftype, vim.bo[bufnr].buftype)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksDashboardOpened",
      callback = function(args)
        vim.b[args.buf].miniindentscope_disable = true
      end,
    })
  end,
  opts = {
    options = { try_as_border = true },
    symbol = "▏",
  },
}
