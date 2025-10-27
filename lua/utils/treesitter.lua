local M = {}

M._available = nil ---@type table<string, boolean>?
M._installed = nil ---@type table<string, boolean>?
M._query = {} ---@type table<string, table<string, boolean>>

---@param opts { update: boolean }?
---@return table<string, boolean>
M.get_available = function(opts)
    if opts and opts.update then
        M._available = {}
        for _, parser in ipairs(require("nvim-treesitter").get_available()) do
            M._available[parser] = true
        end
    end
    return M._available or {}
end

---@param opts { update: boolean }?
---@return table<string, boolean>
M.get_installed = function(opts)
    if opts and opts.update then
        M._installed = {}
        for _, parser in ipairs(require("nvim-treesitter").get_installed("parsers")) do
            M._installed[parser] = true
        end
    end
    return M._installed or {}
end

---@param lang string
---@param query? string
---@return boolean|table<string, boolean>
M.get_query = function(lang, query)
    if not M.get_installed({ update = true })[lang] then
        return false
    end
    if not M._query[lang] then
        M._query[lang] = {}
    end
    if not query then
        return M._query[lang]
    end
    if M._query[lang][query] == nil then
        M._query[lang][query] = vim.treesitter.query.get(lang, query) ~= nil
    end
    return M._query[lang][query]
end

return M
