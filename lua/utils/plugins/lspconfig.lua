---@class utils.plugins.lspconfig
local M = {}

---@param capabilities? lsp.ClientCapabilities
---@return lsp.ClientCapabilities
M.client_capabilities = function(capabilities)
    local has_blink, blink = pcall(require, "blink-cmp")
    return vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
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

    local capabilities = opts.capabilities or {}
    local on_attach = opts.on_attach or {}
    local settings = opts.settings or {}

    require("mason-lspconfig").setup_handlers({
        function(server_name)
            require("lspconfig")[server_name].setup({
                capabilities = vim.tbl_deep_extend("force", capabilities["*"] or {}, capabilities[server_name] or {}),
                on_attach = on_attach[server_name] or on_attach["*"],
                settings = settings[server_name],
            })
        end,
    })
end

return M
