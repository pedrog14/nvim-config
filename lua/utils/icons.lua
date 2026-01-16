local M = {}

M.diagnostic = {
  signs = { "󰅙 ", "󰀨 ", "󰋼 ", "󰋗 " },
  virtual_text = {
    prefix = "●",
  },
}

M.fold = {
  close = "",
  open = "",
}

M.lsp = {
  ---@type string[]
  symbols = setmetatable({}, {
    __index = function(t, k)
      local v = rawget(t, k)

      if not v then
        local mini_icons_ok, mini_icons = pcall(require, "mini.icons")

        if mini_icons_ok then
          v = mini_icons.get("lsp", k)
          rawset(t, k, v)
        end
      end

      return v
    end,
  }),
}

return M
