local M = {}

---@param opts conform.setupOpts
M.setup = function(opts)
  vim.api.nvim_set_option_value("formatexpr", "v:lua.require('conform').formatexpr()", {})

  require("conform").setup(opts)
end

return M
