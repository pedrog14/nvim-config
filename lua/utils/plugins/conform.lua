local M = {}
local conform = require("conform")

---@param opts conform.setupOpts
M.setup = function(opts)
  vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

  conform.setup(opts)
end

return M
