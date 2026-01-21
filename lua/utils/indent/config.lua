local M = {}

---@class indent.config
M.default = {
  filter = {
    filetype = {
      "lspinfo",
      "packer",
      "checkhealth",
      "help",
      "man",
      "gitcommit",
      "dashboard",
      "text",
      "",
    },
    buftype = { "terminal", "quickfix", "nofile", "prompt" },
  },
  char = "▏",
}

M.opts = nil ---@type indent.config?

return M
