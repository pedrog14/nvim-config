---@class utils.lspconfig.EnabledOpts
---@field enabled boolean?
---@field exclude string[]?

---@class utils.lspconfig.Opts: MasonLspconfigSettings
---@field servers         table<string, vim.lsp.Config>?
---@field diagnostic      vim.diagnostic.Opts?
---@field codelens        utils.lspconfig.EnabledOpts?
---@field fold            utils.lspconfig.EnabledOpts?
---@field inlay_hint      utils.lspconfig.EnabledOpts?
---@field semantic_tokens utils.lspconfig.EnabledOpts?

---@class utils.lspconfig.check_enabled.callback.Data
---@field client  vim.lsp.Client
---@field method  vim.lsp.protocol.Method.ClientToServer|vim.lsp.protocol.Method.Registration
---@field bufnr   number?
---@field default boolean?

---@class utils.lspconfig.check_enabled.Data: utils.lspconfig.check_enabled.callback.Data
---@field callback fun(data: utils.lspconfig.check_enabled.callback.Data)

local M = {}

---@param opts utils.lspconfig.Opts
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
  ---@param data utils.lspconfig.check_enabled.Data
  ---@return any
  local check_enabled = function(field, data)
    local option = opts[field] or {} ---@type utils.lspconfig.EnabledOpts
    local exclude, ft = option.exclude or {}, vim.api.nvim_get_option_value("ft", { buf = data.bufnr })
    return (option.enabled == nil and data.default or option.enabled)
      and not vim.tbl_contains(exclude, ft)
      and data.client:supports_method(data.method, data.bufnr)
      and (data:callback() or true)
  end

  local setup_augroup = vim.api.nvim_create_augroup("_setupLSPConfig", { clear = true })
  local augroup = vim.api.nvim_create_augroup("LSPConfig", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = setup_augroup,
    callback = function(args)
      local bufnr = vim._resolve_bufnr(args.buf)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      local client_id = vim.tbl_get(args, "data", "client_id")
      if not client_id then
        return
      end

      local client = vim.lsp.get_client_by_id(client_id)
      if not client then
        return
      end

      check_enabled("codelens", {
        client = client,
        method = "textDocument/codeLens",
        bufnr = bufnr,
        default = false,
        callback = function(data)
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            group = augroup,
            buffer = bufnr,
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
        bufnr = bufnr,
        default = false,
        callback = function(data)
          vim.lsp.inlay_hint.enable(true, { bufnr = data.bufnr })
        end,
      })

      check_enabled("semantic_tokens", {
        client = client,
        method = "textDocument/semanticTokens",
        bufnr = bufnr,
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

  vim.api.nvim_create_autocmd("LspDetach", {
    group = setup_augroup,
    callback = function(args)
      local bufnr = vim._resolve_bufnr(args.buf)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    end,
  })
end

return M
