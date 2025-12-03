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
    local utils = require("utils.lsp")

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
    ---@param data { ft: string, default: boolean }
    ---@return boolean
    local is_enabled = function(field, data)
        local opt = opts[field] or {} ---@type {enabled: boolean, exclude: string[]}
        local exclude = opt.exclude or {}
        return (opt.enabled ~= nil or data.default) and not vim.tbl_contains(exclude, data.ft)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LSPConfig", { clear = true }),
        callback = function(args)
            local bufnr = args.buf

            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })

            -- LSPConfig settings
            if is_enabled("semantic_tokens", { ft = ft, default = true }) then
                utils.on_supports_method(client, "textDocument/semanticTokens/full", bufnr, function()
                    vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
                end)
            end
            if is_enabled("codelens", { ft = ft, default = false }) then
                utils.on_supports_method(client, "textDocument/codeLens", bufnr, function()
                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.codelens.refresh({ bufnr = bufnr })
                        end,
                    })
                end)
            end
            if is_enabled("inlay_hint", { ft = ft, default = false }) then
                utils.on_supports_method(client, "textDocument/inlayHint", bufnr, function()
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end)
            end
            if is_enabled("fold", { ft = ft, default = false }) then
                utils.on_supports_method(client, "textDocument/foldingRange", bufnr, function()
                    local win = vim.api.nvim_get_current_win()
                    vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
                    vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { win = win })
                end)
            end

            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, { desc = "Displays hover information about the symbol under the cursor", buffer = bufnr })
        end,
    })
end

return M
