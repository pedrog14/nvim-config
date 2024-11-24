local _ = require("mason-core.functional")
local settings = require("mason-conform.settings")
local platform = require("mason-core.platform")

local M = {}

local function check_and_notify_bad_setup_order()
    local mason_ok, mason = pcall(require, "mason")
    local is_bad_order = not mason_ok or mason.has_setup == false
    local impacts_functionality = not mason_ok or #settings.current.ensure_installed > 0
    if is_bad_order and impacts_functionality then
        require("mason-conform.notify")(
            "mason.nvim has not been set up. Make sure to set up 'mason' before 'mason-conform'.",
            vim.log.levels.WARN
        )
    end
end

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
        registry.register_package_aliases(_.map(function(formatter_name)
            return { formatter_name }
        end, require("mason-conform.mappings.formatter").package_to_conform))
    end

    require("mason-conform.api.command")
end

return M
