local M = {}

---@class utils.lsp.breadcrumbs.Opts
M.default = {
  icons = {
    symbols = require("utils.icons").lsp.symbols,
    separator = "",
  },
}

M.opts = nil ---@type utils.lsp.breadcrumbs.Opts?

return M
