local M = {}

---@return (string?)[]
local get_symbols = function()
  local symbols = {}
  local mini_icons_ok, mini_icons = pcall(require, "mini.icons")

  if mini_icons_ok then
    local symbol_kind = vim.lsp.protocol.SymbolKind
    for _, kind in ipairs(symbol_kind) do
      symbols[kind] = mini_icons.get("lsp", kind --[[@as string]])
    end
  end

  return symbols
end

---@class utils.lsp.breadcrumbs.Opts
M.default = {
  icons = {
    symbols = get_symbols(),
    separator = "",
    ellipsis = "…",
  },
}

M.opts = nil ---@type utils.lsp.breadcrumbs.Opts?

return M
