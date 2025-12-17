local M = {}

M.diagnostic = {
  signs = setmetatable({ "󰅙 ", "󰀨 ", "󰋼 ", "󰋗 " }, {
    __index = function(t, k)
      local map = {
        e = 1,
        E = 1,
        error = 1,
        ERROR = 1,

        w = 2,
        W = 2,
        warn = 2,
        WARN = 2,
        warning = 2,
        WARNING = 2,

        i = 3,
        I = 3,
        info = 3,
        INFO = 3,

        h = 4,
        H = 4,
        hint = 4,
        HINT = 4,
      }

      local pos = map[k]

      if not pos then
        return
      end

      return t[pos]
    end,
  }),
  virtual_text = {
    prefix = "●",
  },
}

return M
