return {
    "neovim/nvim-lspconfig",
    dependencies = "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    main = "utils.plugins.lspconfig",
    ---@module "types"
    ---@type lspconfig.Opts
    opts = {
        ["*"] = {
            capabilities = require("utils.plugins.lspconfig").client_capabilities(),
        },
        lua_ls = {
            settings = {
                Lua = { workspace = { checkThirdParty = false } },
            },
        },
    },
}
