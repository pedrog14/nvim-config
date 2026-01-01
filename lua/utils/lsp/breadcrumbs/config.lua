local M = {}

---@return string[]
local get_symbols = function()
  -- stylua: ignore
  local symbols = {
    File          = "F",
    Module        = "M",
    Namespace     = "N",
    Package       = "P",
    Class         = "C",
    Method        = "M",
    Property      = "P",
    Field         = "F",
    Constructor   = "C",
    Enum          = "E",
    Interface     = "I",
    Function      = "F",
    Variable      = "V",
    Constant      = "C",
    String        = "S",
    Number        = "N",
    Boolean       = "B",
    Array         = "A",
    Object        = "O",
    Key           = "K",
    Null          = "N",
    EnumMember    = "E",
    Struct        = "S",
    Event         = "E",
    Operator      = "O",
    TypeParameter = "T",
  }

  local mini_icons_ok, mini_icons = pcall(require, "mini.icons")

  if mini_icons_ok then
    for kind, _ in pairs(symbols) do
      symbols[kind] = mini_icons.get("lsp", kind)
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
  max_symbols = 6,
}

M.opts = nil ---@type utils.lsp.breadcrumbs.Opts?

return M
