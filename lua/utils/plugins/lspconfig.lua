---@class utils.lspconfig.opts: MasonLspconfigSettings
---@field servers? table<string, vim.lsp.Config>
---@field diagnostic? vim.diagnostic.Opts
---@field codelens? { enabled: boolean, exclude: string[] }
---@field inlay_hint? { enabled: boolean, exclude: string[] }
---@field fold? { enabled: boolean, exclude: string[] }
---@field semantic_tokens? { enabled: boolean, exclude: string[] }

local M = {}

---@param opts utils.lspconfig.opts
M.setup = function(opts)
    if opts.diagnostic then
        vim.diagnostic.config(opts.diagnostic)
    end

    if opts.servers then
        for lang, content in pairs(opts.servers) do
            vim.lsp.config(lang, content)
        end
    end

    require("mason-lspconfig").setup({
        automatic_enable = opts.automatic_enable,
        ensure_installed = opts.ensure_installed,
    })

    ---@param field string
    ---@param data { client: vim.lsp.Client, method: vim.lsp.protocol.Method.ClientToServer, buf: number?, ft: string, default: boolean }
    ---@return boolean
    local is_enabled = function(field, data)
        local opt = opts[field] or {} ---@type { enabled: boolean, exclude: string[] }
        local exclude = opt.exclude or {}
        return (opt.enabled ~= nil and opt.enabled or data.default)
            and not vim.tbl_contains(exclude, data.ft)
            and data.client:supports_method(data.method, data.buf)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LSPConfig", { clear = true }),
        callback = function(args)
            local bufnr = args.buf

            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then
                return
            end

            local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })

            if
                is_enabled("semantic_tokens", {
                    client = client,
                    method = "textDocument/semanticTokens/full",
                    buf = bufnr,
                    ft = ft,
                    default = true,
                })
            then
                vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
            end

            if
                is_enabled("codelens", {
                    client = client,
                    method = "textDocument/codeLens",
                    buf = bufnr,
                    ft = ft,
                    default = false,
                })
            then
                vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.codelens.refresh({ bufnr = bufnr })
                    end,
                })
            end

            if
                is_enabled("inlay_hint", {
                    client = client,
                    method = "textDocument/inlayHint",
                    buf = bufnr,
                    ft = ft,
                    default = false,
                })
            then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end

            if
                is_enabled("fold", {
                    client = client,
                    method = "textDocument/foldingRange",
                    buf = bufnr,
                    ft = ft,
                    default = false,
                })
            then
                local win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
                vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { win = win })
            end

            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, { desc = "Displays hover information about the symbol under the cursor", buffer = bufnr })
        end,
    })
end

return M
