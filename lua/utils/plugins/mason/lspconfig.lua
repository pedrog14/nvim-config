local functional = require("mason-core.functional")
local settings = require("mason-lspconfig.settings")
local platform = require("mason-core.platform")

---@class utils.plugins.mason.lspconfig
local M = {}

local check_and_notify_bad_setup_order = function()
    local mason_ok, mason = pcall(require, "mason")
    local is_bad_order = not mason_ok or mason.has_setup == false
    local impacts_functionality = not mason_ok or #require("mason-lspconfig.settings").current.ensure_installed > 0
    return function()
        if is_bad_order and impacts_functionality then
            vim.notify(
                "mason.nvim has not been set up. Make sure to set up 'mason' before 'mason-lspconfig'.",
                vim.log.levels.WARN,
                { title = "mason-lspconfig.nvim" }
            )
        end
    end
end

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
        registry.register_package_aliases(functional.map(function(server_name)
            return { server_name }
        end, require("mason-lspconfig.mappings.server").package_to_lspconfig))
    end

    require("mason-lspconfig.api.command")
end

return M
