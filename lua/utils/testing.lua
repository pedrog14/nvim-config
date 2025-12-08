local M = {}

---@param callback function
---@param arg1? any
---@return number, any ...
M.benchmark = function(callback, arg1, ...)
    local start_time = vim.uv.hrtime()
    local output = callback(arg1, ...)
    local end_time = vim.uv.hrtime()

    return end_time - start_time, output
end

return M
