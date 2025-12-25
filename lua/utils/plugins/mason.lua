---@class utils.mason.Opts: MasonSettings
---@field ensure_installed string[]?

local M = {}
local mason = require("mason")
local registry = require("mason-registry")

---@param opts utils.mason.Opts
M.setup = function(opts)
  opts = opts or {}

  mason.setup(opts)

  registry:on("package:install:success", function()
    vim.defer_fn(function()
      vim.api.nvim_exec_autocmds("FileType", {
        buffer = vim.api.nvim_get_current_buf(),
      })
    end, 100)
  end)

  if not opts.ensure_installed then
    return
  end

  registry.refresh(vim.schedule_wrap(function()
    local Package = require("mason-core.package")

    for _, pkg_identifier in ipairs(opts.ensure_installed) do
      local pkg_name, version = Package.Parse(pkg_identifier)
      local pkg_ok, pkg = pcall(registry.get_package, pkg_name)

      if pkg_ok then
        if not pkg:is_installed() then
          pkg:install({ version = version })
        end
      else
        vim.notify(
          ("[mason.nvim] Package %q is not a valid entry in ensure_installed. Make sure to only provide mason package names."):format(
            pkg_name
          ),
          vim.log.levels.WARN
        )
      end
    end
  end))
end

return M
