---@alias utils.lspconfig.EnabledOpts { enabled: boolean, exclude: string[] }

---@class utils.lspconfig.check_enabled.callback.Data
---@field client vim.lsp.Client
---@field method vim.lsp.protocol.Method.ClientToServer|vim.lsp.protocol.Method.Registration
---@field ft     string
---@field bufnr  integer

---@class utils.lspconfig.check_enabled.Data: utils.lspconfig.check_enabled.callback.Data
---@field callback fun(data: utils.lspconfig.check_enabled.callback.Data)

local M = {}
local mason_lspconfig = require("mason-lspconfig")
local augroup = nil ---@type integer?

---@param field string
---@param data utils.lspconfig.check_enabled.Data
---@return any
local check_enabled = function(field, data)
  ---@type utils.lspconfig.EnabledOpts
  local option = vim.tbl_get(M.config, "opts", field) or {}
  local exclude = option.exclude or {}
  return option.enabled
    and not vim.tbl_contains(exclude, data.ft)
    and data.client:supports_method(data.method, data.bufnr)
    and (data:callback() or true)
end

---@param args vim.api.keyset.create_autocmd.callback_args
local on_attach = vim.schedule_wrap(function(args)
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

  local ft = vim.api.nvim_get_option_value("ft", { buf = bufnr })

  check_enabled("codelens", {
    client = client,
    method = "textDocument/codeLens",
    ft = ft,
    bufnr = bufnr,
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

  -- check_enabled("completion", {
  --   client = client,
  --   method = "textDocument/completion",
  --   ft = ft,
  --   bufnr = bufnr,
  --   callback = function(data)
  --     ---@type lsp.Handler
  --     local handler = data.client[data.method]
  --     ---@type lsp.Handler
  --     data.client.handlers[data.method] = function(err, result, context, config)
  --       vim.print(err, result, context, config)
  --       handler(err, result, context, config)
  --     end
  --   end,
  -- })
  --
  check_enabled("fold", {
    client = client,
    method = "textDocument/foldingRange",
    ft = ft,
    bufnr = bufnr,
    callback = function()
      local win = vim.api.nvim_get_current_win()

      vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
      vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { win = win })
    end,
  })

  check_enabled("inlay_hint", {
    client = client,
    method = "textDocument/inlayHint",
    ft = ft,
    bufnr = bufnr,
    callback = function(data)
      vim.lsp.inlay_hint.enable(true, { bufnr = data.bufnr })
    end,
  })

  check_enabled("semantic_tokens", {
    client = client,
    method = "textDocument/semanticTokens",
    ft = ft,
    bufnr = bufnr,
    callback = function(data)
      vim.lsp.semantic_tokens.enable(true, { bufnr = data.bufnr })
    end,
  })

  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, { desc = "Displays hover information about the symbol under the cursor", buffer = bufnr })
end)

---@param args vim.api.keyset.create_autocmd.callback_args
local on_detach = vim.schedule_wrap(function(args)
  local bufnr = vim._resolve_bufnr(args.buf)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
end)

M.config = {
  ---@class utils.lspconfig.Opts: MasonLspconfigSettings
  ---@field diagnostic      vim.diagnostic.Opts?
  ---@field servers         table<string, vim.lsp.Config>?
  ---@field codelens        utils.lspconfig.EnabledOpts?
  ---@field fold            utils.lspconfig.EnabledOpts?
  ---@field inlay_hint      utils.lspconfig.EnabledOpts?
  ---@field semantic_tokens utils.lspconfig.EnabledOpts?
  default = {
    codelens = { enabled = false },
    fold = { enabled = false },
    inlay_hint = { enabled = false },
    semantic_tokens = { enabled = true },
  },

  opts = nil, ---@type utils.lspconfig.Opts?
}

---@param opts utils.lspconfig.Opts?
M.setup = function(opts)
  M.config.opts = vim.tbl_deep_extend("force", M.config.default, opts or {})
  augroup = vim.api.nvim_create_augroup("LSPConfig", { clear = true })

  local setup_augroup = vim.api.nvim_create_augroup("_setupLSPConfig", { clear = true })

  local diagnostic = vim.tbl_get(M.config, "opts", "diagnostic")
  if diagnostic then
    vim.diagnostic.config(diagnostic)
  end

  local servers = vim.tbl_get(M.config, "opts", "servers")
  if servers then
    for lang, content in pairs(servers) do
      vim.lsp.config(lang, content)
    end
  end

  mason_lspconfig.setup(M.config.opts)

  vim.api.nvim_create_autocmd("LspAttach", { group = setup_augroup, callback = on_attach })
  vim.api.nvim_create_autocmd("LspDetach", { group = setup_augroup, callback = on_detach })
end

return M
