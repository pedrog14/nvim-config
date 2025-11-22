local M = {}

---@param callback fun(...): any
---@return number, any
M.benchmark = function(callback, ...)
    local start_time = os.clock()
    local output = callback(...)
    local end_time = os.clock()

    return end_time - start_time, output
end

return M
