local M = {}

---@param callback fun(...: any): any
---@param arg1? any
---@return number, any ...
M.benchmark = function(callback, arg1, ...)
    local start_time = os.clock()
    local output = callback(arg1, ...)
    local end_time = os.clock()

    return end_time - start_time, output
end

return M
