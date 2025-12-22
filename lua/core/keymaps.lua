---@class core.keymap.Set: vim.keymap.set.Opts
---@field [1] string
---@field [2] string|function
---@field mode? string|string[]

local M = {}

---@param keymaps core.keymap.Set[]
M.set = function(keymaps)
  keymaps = keymaps or {}

  for _, keymap in ipairs(keymaps) do
    local mode = type(keymap.mode) == "table" and vim.deepcopy(keymap.mode --[[@as table]])
      or keymap.mode
      or "n"
    keymap.mode = nil

    local lhs = table.remove(keymap, 1)
    local rhs = table.remove(keymap, 1)
    local opts = keymap

    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M
