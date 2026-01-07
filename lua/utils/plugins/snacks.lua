---@class utils.snacks.Indent: snacks.indent.Config
---@field filter (utils.snacks.indent.Filter|fun(buf: number?, win: number?): boolean)?

---@class utils.snacks.indent.Filter
---@field filetype string[]?

---@class utils.snacks.Opts: snacks.Config
---@field indent utils.snacks.Indent?

local M = {}
local snacks = require("snacks")

---@param filetype string[]
---@return fun(bufnr: integer): boolean
local gen_filter = function(filetype)
  return function(bufnr)
    return not vim.tbl_contains(filetype, vim.bo[bufnr].filetype)
      and vim.g.snacks_indent ~= false
      and vim.b[bufnr].snacks_indent ~= false
      and vim.bo[bufnr].buftype == ""
  end
end

---@module "snacks"
---@param opts utils.snacks.Opts
M.setup = function(opts)
  opts = opts or {}

  ---@type { filetype: string[] }|fun(buf: integer, win: integer?): boolean
  local filter = vim.tbl_get(opts, "indent", "filter")
  filter = type(filter) == "table" and gen_filter(filter.filetype) or filter
  opts.indent = filter and vim.tbl_deep_extend("force", opts.indent, { filter = filter })

  snacks.setup(opts)

  local lazygit = snacks.lazygit
  vim.api.nvim_create_user_command("LazyGit", function(args)
    if vim.tbl_contains(vim.tbl_keys(lazygit), args.args) then
      lazygit[args.args]()
    elseif args.args == "" then
      lazygit --[[@as function]]()
    end
  end, {
    nargs = "?",
    desc = "Open LazyGit",
    complete = function(_, cmdline)
      return #vim.split(cmdline, " ", { trimempty = true }) == 1
        and vim.tbl_filter(function(value)
          return value ~= "health" and value ~= "meta"
        end, vim.tbl_keys(lazygit))
    end,
  })
end

return M
