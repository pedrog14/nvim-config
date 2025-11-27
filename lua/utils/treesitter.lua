local M = {}

local _available = nil ---@type table<string, boolean>?
local _installed = nil ---@type table<string, boolean>?
local _query = {} ---@type table<string, table<string, boolean>>

---@param opts? { update: boolean }
---@return table<string, boolean>
M.get_available = function(opts)
    opts = opts or {}
    if opts.update then
        _available = {}
        for _, parser in ipairs(require("nvim-treesitter").get_available()) do
            _available[parser] = true
        end
    end
    return _available or {}
end

---@param opts? { update: boolean }
---@return table<string, boolean>
M.get_installed = function(opts)
    opts = opts or {}
    if opts.update then
        _installed = {}
        for _, parser in ipairs(require("nvim-treesitter").get_installed("parsers")) do
            _installed[parser] = true
        end
    end
    return _installed or {}
end

---@param lang string
---@param query? string
---@return boolean|table<string, boolean>
M.get_query = function(lang, query)
    if not M.get_installed({ update = true })[lang] then
        return false
    end
    if not _query[lang] then
        _query[lang] = {}
    end
    if not query then
        return _query[lang]
    end
    if _query[lang][query] == nil then
        _query[lang][query] = vim.treesitter.query.get(lang, query) ~= nil
    end
    return _query[lang][query]
end

return M
