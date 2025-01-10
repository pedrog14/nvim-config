local M = {}

M.setup = function(opts)
    require("mason").setup(opts)

    local ensure_installed = opts.ensure_installed or {}
    for _, pkg in ipairs(ensure_installed) do
        local mason_pkg = require("mason-registry").get_package(pkg)
        if not mason_pkg:is_installed() then
            mason_pkg:install()
        end
    end
end

setmetatable(M, {
    __index = function(_, k)
        return require("utils.plugins.mason." .. k)
    end,
})

return M
