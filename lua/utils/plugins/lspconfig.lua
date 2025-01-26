---@class utils.plugins.lspconfig
local M = {}

---@param capabilities? lsp.ClientCapabilities
---@return lsp.ClientCapabilities
M.client_capabilities = function(capabilities)
    return vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        capabilities or {}
    )
end

---@param opts lspconfig.Opts
M.setup = function(opts)
    -- mason-lspconfig snippet
    local log = require("mason-core.log")
    local ok, err = pcall(function()
        require("mason-lspconfig.lspconfig_hook")()
        require("mason-lspconfig.server_config_extensions")()
    end)
    if not ok then
        log.error("Failed to set up lspconfig integration.", err)
    end
    -- END snippet

    require("mason-lspconfig").setup_handlers({
        function(server_name)
            local capabilities, on_attach, settings =
                opts.capabilities,
                opts.on_attach,
                opts.settings and opts.settings[server_name]
            require("lspconfig")[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = settings,
            })
        end,
    })
end

return M
