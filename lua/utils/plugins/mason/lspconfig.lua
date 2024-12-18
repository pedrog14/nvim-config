local _ = require("mason-core.functional")
local log = require("mason-core.log")
local settings = require("mason-lspconfig.settings")
local platform = require("mason-core.platform")

---@class utils.plugins.mason.lspconfig
local M = {}

local check_and_notify_bad_setup_order =
    require("utils.plugins.mason").check_and_notify_bad_setup_order("lspconfig")

M.setup = function(config)
    if config then
        settings.set(config)
    end

    check_and_notify_bad_setup_order()

    if not platform.is_headless and #settings.current.ensure_installed > 0 then
        require("mason-lspconfig.ensure_installed")()
    end

    local registry = require("mason-registry")
    if registry.register_package_aliases then
        registry.register_package_aliases(
            _.map(
                function(server_name)
                    return { server_name }
                end,
                require("mason-lspconfig.mappings.server").package_to_lspconfig
            )
        )
    end

    require("mason-lspconfig.api.command")
end

return M
