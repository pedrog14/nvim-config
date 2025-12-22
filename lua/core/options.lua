---@class core.Opts
---@field g? table<string, any>
---@field o? table<string, any>

local M = {}

---@param opts core.Opts
M.set = function(opts)
  opts = opts or {}

  if opts.g then
    for name, value in pairs(opts.g) do
      vim.api.nvim_set_var(name, value)
    end
  end

  if opts.o then
    for name, value in pairs(opts.o) do
      vim.api.nvim_set_option_value(name, value, {})
    end
  end
end

return M
