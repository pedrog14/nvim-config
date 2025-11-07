---@class lspconfig.opts: MasonLspconfigSettings
---@field diagnostic? vim.diagnostic.Opts
---@field servers? table<string, vim.lsp.Config>
---@field codelens? {enabled: boolean, exclude: string[]}
---@field inlay_hint? {enabled: boolean, exclude: string[]}
---@field fold? {enabled: boolean, exclude: string[]}

local M = {}

---@param opts lspconfig.opts
M.setup = function(opts)
    if opts.diagnostic then
        vim.diagnostic.config(opts.diagnostic)
    end

    if opts.servers then
        for lang, content in pairs(opts.servers) do
            vim.lsp.config(lang, content)
        end
    end

    ---@type MasonLspconfigSettings
    local mason_lspconfig_opts = {
        automatic_enable = opts.automatic_enable,
        ensure_installed = opts.ensure_installed,
    }

    require("mason-lspconfig").setup(mason_lspconfig_opts)

    ---@param field string
    ---@param ft string
    ---@return boolean
    local is_enabled = function(field, ft)
        local option = opts[field] or {}
        local exclude = option.exclude or {}
        return option.enabled and not vim.tbl_contains(exclude, ft)
    end

    ---@param data {buffer: number|nil, client: vim.lsp.Client, method: vim.lsp.protocol.Method}
    ---@param callback fun(buf?: number, client?: vim.lsp.Client)
    local on_supports_method = function(data, callback)
        if data.client:supports_method(data.method, data.buffer) then
            callback(data.buffer, data.client)
        end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_config", { clear = true }),
        callback = vim.schedule_wrap(function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })

            if is_enabled("codelens", ft) then
                on_supports_method(
                    { client = client, buffer = args.buf, method = "textDocument/codeLens" },
                    function(buf)
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            buffer = buf,
                            callback = vim.lsp.codelens.refresh,
                        })
                    end
                )
            end

            if is_enabled("inlay_hint", ft) then
                on_supports_method(
                    { client = client, buffer = args.buf, method = "textDocument/inlayHint" },
                    function(buf)
                        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
                    end
                )
            end

            if is_enabled("fold", ft) then
                on_supports_method(
                    { client = client, buffer = args.buf, method = "textDocument/foldingRange" },
                    function()
                        local win = vim.api.nvim_get_current_win()
                        vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
                        vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { win = win })
                    end
                )
            end
        end),
    })
end

return M
