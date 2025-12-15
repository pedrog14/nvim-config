local M = {}

M.map = vim.tbl_map

M.filter = vim.tbl_filter

--- Implemented as foldl
---@param fn fun(a: any, b: any): any
---@param t any[]
---@return any
M.reduce = function(fn, t)
  local t_keys = vim.tbl_keys(t)
  local acc = t[table.remove(t_keys)]
  for _, key in ipairs(t_keys) do
    acc = fn(acc, t[key])
  end
  return acc
end

return M
