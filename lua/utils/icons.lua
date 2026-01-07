local M = {}
local mini_icons_ok, mini_icons = pcall(require, "mini.icons")

M.diagnostic = {
  signs = { "󰅙 ", "󰀨 ", "󰋼 ", "󰋗 " },
  virtual_text = {
    prefix = "●",
  },
}

M.lsp = {
  ---@type string[]
  symbols = setmetatable({}, {
    __index = function(t, k)
      if not rawget(t, k) and mini_icons_ok then
        t[k] = mini_icons.get("lsp", k)
      end
      return t[k]
    end,
  }),
}

return M
