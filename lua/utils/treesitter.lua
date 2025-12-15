---@alias utils.treesitter.QueryType
---|"highlights"
---|"locals"
---|"folds"
---|"indents"
---|"injections"
---|"textobjects"

---@alias utils.treesitter.QueryList table<utils.treesitter.QueryType, boolean>

local M = {}

local _installed = nil ---@type table<string, boolean>?
local _query = nil ---@type table<string, utils.treesitter.QueryList>?

---@param lang string?
---@param opts { update: boolean }?
---@return boolean|table<string, boolean>
M.get_installed = function(lang, opts)
  opts = opts or {}
  if opts.update then
    _installed = {}
    for _, parser in ipairs(require("nvim-treesitter").get_installed("parsers")) do
      _installed[parser] = true
    end
  end
  if lang then
    return _installed and _installed[lang] or false
  end
  return _installed or {}
end

---@param lang string?
---@param query utils.treesitter.QueryType?
---@return boolean|utils.treesitter.QueryList|table<string, utils.treesitter.QueryList>
M.get_query = function(lang, query)
  _query = _query or {}
  if not lang then
    return _query
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
