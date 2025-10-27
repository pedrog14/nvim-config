---@class lspconfig.opts
---@field diagnostic? vim.diagnostic.Opts
---@field servers? table<string, vim.lsp.Config>
---@field codelens? { enabled: boolean }
---@field inlay_hint? { enabled: boolean }
---@field fold? { enabled: boolean }

local M = {}

---@param opts lspconfig.opts
M.setup = vim.schedule_wrap(function(opts)
    if opts.diagnostic then
        vim.diagnostic.config(opts.diagnostic)
    end

    if opts.servers then
        for lang, content in pairs(opts.servers) do
            vim.lsp.config(lang, content)
        end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_config", { clear = true }),
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

            ---@param method vim.lsp.protocol.Method
            ---@param callback fun(buf?: number, client?: vim.lsp.Client)
            local on_supports_method = function(method, callback)
                if Snacks then
                    Snacks.util.lsp.on({ method = method }, callback)
                else
                    if client:supports_method(method, args.buf) then
                        callback(args.buf, client)
                    end
                end
            end

            if vim.tbl_get(opts, "codelens", "enabled") then
                on_supports_method("textDocument/codeLens", function()
                    vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = args.buf,
                        callback = vim.lsp.codelens.refresh,
                    })
                end)
            end

            if vim.tbl_get(opts, "inlay_hint", "enabled") then
                on_supports_method("textDocument/inlayHint", function(buf)
                    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
                end)
            end

            if vim.tbl_get(opts, "fold", "enabled") then
                on_supports_method("textDocument/foldingRange", function()
                    local win = vim.api.nvim_get_current_win()
                    vim.wo[win][0].foldmethod = "expr"
                    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                end)
            end
        end,
    })
end)

return M
