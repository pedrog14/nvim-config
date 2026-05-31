---@class OptsTable<K>: { [K]: table<string, any> }
---@alias core.Opts OptsTable<"g"|"o">

local M = {}

---@param opts core.Opts
M.setup = function(opts)
  opts = opts or {}

  for var, dict in pairs(opts) do
    for name, value in pairs(dict) do
      vim[var][name] = value
    end
  end
end

return M
