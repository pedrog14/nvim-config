---@class utils.plugins.mason
---@field conform utils.plugins.mason.conform
---@field lspconfig utils.plugins.mason.lspconfig
local M = {}

setmetatable(M, {
    __index = function(t, k)
        return require("utils.plugins.mason." .. k)
    end,
})

M.check_and_notify_bad_setup_order = function(extension)
    local mason_ok, mason = pcall(require, "mason")
    local is_bad_order = not mason_ok or mason.has_setup == false
    local impacts_functionality = not mason_ok
        or #require("mason-" .. extension .. ".settings").current.ensure_installed > 0
    return function()
        if is_bad_order and impacts_functionality then
            vim.notify(
                ("mason.nvim has not been set up. Make sure to set up 'mason' before 'mason-%s'."):format(extension),
                vim.log.levels.WARN,
                {
                    title = ("mason-%s.nvim"):format(extension),
                }
            )
        end
    end
end

return M
