local M = {}
local pack = require("utils.pack")

---@param cmd string
---@param spec utils.pack.SpecResolved
local cmd_load = function(cmd, spec)
  vim.api.nvim_del_user_command(cmd)
  pack.load(spec)
end

---@param cmd string
---@param spec utils.pack.SpecResolved
local cmd_create = function(cmd, spec)
  vim.api.nvim_create_user_command(cmd, function(args)
    ---@type vim.api.keyset.cmd
    local command = {
      cmd = cmd,
      bang = args.bang or nil,
      mods = args.smods,
      args = args.fargs,
      count = args.count >= 0 and args.range == 0 and args.count or nil,
    }

    if args.range == 1 then
      command.range = { args.line1 }
    elseif args.range == 2 then
      command.range = { args.line1, args.line2 }
    end

    cmd_load(cmd, spec)

    local info = vim.api.nvim_get_commands({})[cmd] or vim.api.nvim_buf_get_commands(0, {})[cmd]
    if not info then
      vim.schedule(vim.notify)("Command " .. cmd .. " not found after loading " .. spec.name, vim.log.levels.ERROR)
      return
    end

    command.nargs = info.nargs
    if args.args and args.args ~= "" and info.nargs and info.nargs:find("[1?]") then
      command.args = { args.args }
    end

    vim.api.nvim_cmd(command, {})
  end, {
    bang = true,
    range = true,
    nargs = "*",
    complete = function(_, line)
      cmd_load(cmd, spec)
      return vim.fn.getcompletion(line, "cmdline")
    end,
  })
end

---@param cmd string|string[]
---@param spec utils.pack.SpecResolved
M.load = function(cmd, spec)
  if type(cmd) == "table" then
    for _, c in ipairs(cmd) do
      cmd_create(c, spec)
    end
  else
    cmd_create(cmd, spec)
  end
end

return M
