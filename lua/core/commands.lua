local M = {}

---@param cmds table<string, string>
M.setup = function(cmds)
  cmds = cmds or {}

  for name, value in pairs(cmds) do
    vim.cmd[name](value)
  end
end

return M
