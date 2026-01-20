---@class utils.snacks.Indent: snacks.indent.Config
---@field filter (utils.snacks.indent.Filter|fun(buf: number?, win: number?): boolean)?

---@class utils.snacks.indent.Filter
---@field filetype string[]?
---@field buftype  string[]?

---@class utils.snacks.Opts: snacks.Config
---@field indent utils.snacks.Indent?

local M = {}
local snacks = require("snacks")

---@param filter { filetype: string[], buftype: string[] }
---@return fun(bufnr: integer): boolean
local gen_filter = function(filter)
  local filetype = {
    lspinfo = true,
    packer = true,
    checkhealth = true,
    help = true,
    man = true,
    gitcommit = true,
    dashboard = true,
    text = true,
  }

  local buftype = {
    terminal = true,
    quickfix = true,
    nofile = true,
    prompt = true,
  }

  for _, value in ipairs(filter.filetype) do
    filetype[value] = true
  end

  for _, value in ipairs(filter.buftype) do
    buftype[value] = true
  end

  return function(bufnr)
    local ft = vim.bo[bufnr].filetype
    local bt = vim.bo[bufnr].buftype

    return vim.g.snacks_indent ~= false
      and vim.b[bufnr].snacks_indent ~= false
      and ft ~= ""
      and not filetype[ft]
      and not buftype[bt]
  end
end

---@module "snacks"
---@param opts utils.snacks.Opts
M.setup = function(opts)
  opts = opts or {}

  ---@type utils.snacks.indent.Filter|fun(buf: integer): boolean
  local filter = opts.indent and (vim.tbl_get(opts, "indent", "filter") or {})
  filter = type(filter) == "table"
      and gen_filter({
        filetype = filter.filetype or {},
        buftype = filter.buftype or {},
      })
    or filter

  if filter then
    opts.indent.filter = filter
  end

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
