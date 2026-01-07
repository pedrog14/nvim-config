local M = {}

---@class utils.lsp.completion.Opts
M.default = {
  icons = {
    symbols = require("utils.icons").lsp.symbols,
    ellipsis = "…",
  },
}

M.opts = nil ---@type utils.lsp.completion.Opts?

return M
