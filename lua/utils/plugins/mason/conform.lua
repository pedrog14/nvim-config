local _ = require("mason-core.functional")
local settings = require("mason-conform.settings")
local platform = require("mason-core.platform")

---@class utils.plugins.mason.conform
local M = {}

local check_and_notify_bad_setup_order =
    require("utils.plugins.mason").check_and_notify_bad_setup_order("conform")

M.setup = function(config)
    if config then
        settings.set(config)
    end

    check_and_notify_bad_setup_order()

    if not platform.is_headless and #settings.current.ensure_installed > 0 then
        require("mason-conform.ensure_installed")()
    end

    local registry = require("mason-registry")
    if registry.register_package_aliases then
        registry.register_package_aliases(
            _.map(function(formatter_name)
                return { formatter_name }
            end, require("mason-conform.mappings.formatter").package_to_conform)
        )
    end

    require("mason-conform.api.command")
end

return M
