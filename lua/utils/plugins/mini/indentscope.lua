local M = {}

local filter_autocmd = function(filter)
  filter = filter or {}
  local default = {
    filetype = { "lspinfo", "packer", "checkhealth", "help", "man", "gitcommit", "dashboard", "text", "" },
    buftype = { "terminal", "quickfix", "nofile", "prompt" },
  }

  local filetype, buftype = {}, {}

  local gen_filter = function(filter_tab)
    for _, value in ipairs(filter_tab.filetype or {}) do
      filetype[value] = true
    end
    for _, value in ipairs(filter_tab.buftype or {}) do
      buftype[value] = true
    end
  end

  gen_filter(default)
  gen_filter(filter)

  vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
    group = vim.api.nvim_create_augroup("FilterIndentScope", { clear = true }),
    callback = function(args)
      local bufnr = args.buf
      local miniindentscope_disable = vim.b[bufnr].miniindentscope_disable

      if miniindentscope_disable == nil then
        vim.b[bufnr].miniindentscope_disable = filetype[vim.bo[bufnr].filetype] or buftype[vim.bo[bufnr].buftype]
      end
    end,
  })

  vim.tbl_map(function(bufnr)
    vim.b[bufnr].miniindentscope_disable = filetype[vim.bo[bufnr].filetype] or buftype[vim.bo[bufnr].buftype]
  end, vim.api.nvim_list_bufs())
end

M.setup = function(opts)
  filter_autocmd(opts.filter)

  require("mini.indentscope").setup(opts)
end

return M
