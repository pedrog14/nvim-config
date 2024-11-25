---@class cmp.Opts
---@field global? cmp.ConfigSchema
---@field cmdline? cmp.ConfigSchema
---@field search? cmp.ConfigSchema

---@class lspconfig.Opts
---@field diagnostics? vim.diagnostic.Opts
---@field settings? table<string, table>
---@field capabilities? lsp.ClientCapabilities
---@field on_attach? fun(client: vim.lsp.Client, bufnr: integer)
