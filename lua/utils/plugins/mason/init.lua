local Package = require("mason-core.package")
local registry = require("mason-registry")

---@class utils.plugins.mason
---@field lspconfig utils.plugins.mason.lspconfig
local M = {}

M.setup = function(opts)
    require("mason").setup(opts)

    opts.ensure_installed = opts.ensure_installed or {}
    registry.refresh(function()
        for _, pkg_identifier in ipairs(opts.ensure_installed) do
            local pkg_name, version = Package.Parse(pkg_identifier)

            local ok, mason_pkg = pcall(registry.get_package, pkg_name)

            if ok then
                if not mason_pkg:is_installed() then
                    mason_pkg:install({ version = version })
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
    end)
end

return M
