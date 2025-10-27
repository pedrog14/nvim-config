local M = {}

---@param callback fun(...)
M.benchmark = function(callback, ...)
    local start_time = os.clock()
    callback(...)
    local end_time = os.clock()

    return end_time - start_time
end

return M
