---@class utils.treesitter.textobjects.Move: TSTextObjects.Config.Move
---@field enabled boolean?
---@field keys    table<string, table<string, string>>?

local textobjects = require("nvim-treesitter-textobjects")
local utils = require("utils.treesitter")

local config = {
  ---@class utils.treesitter.textobjects.Opts: TSTextObjects.UserConfig
  ---@field move? utils.treesitter.textobjects.Move
  default = {
    move = { enabled = true },
  },

  opts = nil, ---@type utils.treesitter.textobjects.Opts
}

---@param field string
---@param data  utils.treesitter.check_enabled.Data
---@return any
local check_enabled = function(field, data)
  local option = vim.tbl_get(config, "opts", field) or {} ---@type { enabled: boolean, exclude: string[] }
  local exclude = option.exclude or {}
  return option.enabled
    and not vim.tbl_contains(exclude, data.lang)
    and utils.get_query(data.lang, data.query)
    and (data:callback() or true)
end

---@param bufnr number
---@param ft    string?
local attach = function(bufnr, ft)
  local lang = vim.treesitter.language.get_lang(ft or vim.api.nvim_get_option_value("ft", { buf = bufnr })) --[[@as string]]
  local is_installed = utils.get_installed(lang)
  if not is_installed then
    return
  end

  check_enabled("move", {
    lang = lang,
    query = "textobjects",
    bufnr = bufnr,
    default = false,
    callback = function(data)
      ---@type table<string, table<string, string>>
      local moves = vim.tbl_get(config, "opts", "move", "keys") or {}

      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local queries = type(query) == "table" and query or { query }
          local parts = {}
          for _, q in ipairs(queries) do
            local part = q:gsub("@", ""):gsub("%..*", "")
            part = part:sub(1, 1):upper() .. part:sub(2)
            table.insert(parts, part)
          end
          local desc = table.concat(parts, " or ")
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          if
            not (vim.api.nvim_get_option_value("diff", { win = vim.api.nvim_get_current_win() }) and key:find("[cC]"))
          then
            vim.keymap.set({ "n", "x", "o" }, key, function()
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = data.bufnr,
              desc = desc,
              silent = true,
            })
          end
        end
      end
    end,
  })
end

local M = {}

---@param opts utils.treesitter.textobjects.Opts
M.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.default, opts or {})

  textobjects.setup(config.opts)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TSConfig", { clear = false }),
    callback = function(args)
      local bufnr, ft = vim._resolve_bufnr(args.buf), args.match
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      attach(bufnr, ft)
    end,
  })

  vim.tbl_map(attach, vim.api.nvim_list_bufs())
end

return M
