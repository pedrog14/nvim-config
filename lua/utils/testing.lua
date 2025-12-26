local M = {}

---@param callback function
---@param arg1 any?
---@return number ms Execution time (in milliseconds)
M.benchmark = function(callback, arg1, ...)
  local start_time = vim.uv.hrtime()
  callback(arg1, ...)
  local end_time = vim.uv.hrtime()

  return (end_time - start_time) * 1e-6
end

return M
