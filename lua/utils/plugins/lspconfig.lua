---@class utils.lspconfig.opts: MasonLspconfigSettings
---@field servers         table<string, vim.lsp.Config>?
---@field diagnostic      vim.diagnostic.Opts?
---@field codelens        { enabled: boolean, exclude: string[] }?
---@field fold            { enabled: boolean, exclude: string[] }?
---@field inlay_hint      { enabled: boolean, exclude: string[] }?
---@field semantic_tokens { enabled: boolean, exclude: string[] }?

---@class utils.lspconfig.check_enabled.callback.data
---@field client  vim.lsp.Client
---@field method  vim.lsp.protocol.Method.ClientToServer|vim.lsp.protocol.Method.Registration
---@field bufnr   number?
---@field default boolean?

---@class utils.lspconfig.check_enabled.data: utils.lspconfig.check_enabled.callback.data
---@field callback fun(data: utils.lspconfig.check_enabled.callback.data)

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
  ---@param data utils.lspconfig.check_enabled.data
  ---@return any
  local check_enabled = function(field, data)
    local option = opts[field] or {} ---@type { enabled: boolean, exclude: string[] }
    local exclude, ft = option.exclude or {}, vim.api.nvim_get_option_value("ft", { buf = data.bufnr })
    return (option.enabled == nil and data.default or option.enabled)
      and not vim.tbl_contains(exclude, ft)
      and data.client:supports_method(data.method, data.bufnr)
      and (data:callback() or true)
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LSPConfig", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      check_enabled("codelens", {
        client = client,
        method = "textDocument/codeLens",
        bufnr = args.buf,
        default = false,
        callback = function(data)
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = args.buf,
            callback = function()
              vim.lsp.codelens.refresh({ bufnr = data.bufnr })
            end,
          })
        end,
      })

      check_enabled("fold", {
        client = client,
        method = "textDocument/foldingRange",
        default = false,
        callback = function()
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
          vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { win = win })
        end,
      })

      check_enabled("inlay_hint", {
        client = client,
        method = "textDocument/inlayHint",
        bufnr = args.buf,
        default = false,
        callback = function(data)
          vim.lsp.inlay_hint.enable(true, { bufnr = data.bufnr })
        end,
      })

      check_enabled("semantic_tokens", {
        client = client,
        method = "textDocument/semanticTokens",
        bufnr = args.buf,
        default = true,
        callback = function(data)
          vim.lsp.semantic_tokens.enable(true, { bufnr = data.bufnr })
        end,
      })

      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
      end, { desc = "Displays hover information about the symbol under the cursor", buffer = args.buf })
    end,
  })
end

return M
