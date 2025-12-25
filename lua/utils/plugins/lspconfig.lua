---@alias utils.lspconfig.EnabledOpts { enabled: boolean, exclude: string[] }

---@class utils.lspconfig.check_enabled.callback.Data
---@field client vim.lsp.Client
---@field method vim.lsp.protocol.Method.ClientToServer|vim.lsp.protocol.Method.Registration
---@field ft     string
---@field bufnr  integer

---@class utils.lspconfig.check_enabled.Data: utils.lspconfig.check_enabled.callback.Data
---@field callback fun(data: utils.lspconfig.check_enabled.callback.Data)

local augroup = nil

local config = {
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

---@param field string
---@param data utils.lspconfig.check_enabled.Data
---@return any
local check_enabled = function(field, data)
  ---@type utils.lspconfig.EnabledOpts
  local option = vim.tbl_get(config, "opts", field) or {}
  local exclude = option.exclude or {}
  return option.enabled
    and not vim.tbl_contains(exclude, data.ft)
    and data.client:supports_method(data.method, data.bufnr)
    and (data:callback() or true)
end

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

local on_detach = vim.schedule_wrap(function(args)
  local bufnr = vim._resolve_bufnr(args.buf)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.keymap.del("n", "K", { buffer = bufnr })
end)

local M = {}

---@param opts utils.lspconfig.Opts
M.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.default, opts or {})

  local diagnostic = vim.tbl_get(config, "opts", "diagnostic")
  if diagnostic then
    vim.diagnostic.config(diagnostic)
  end

  local servers = vim.tbl_get(config, "opts", "servers")
  if servers then
    for lang, content in pairs(servers) do
      vim.lsp.config(lang, content)
    end
  end

  require("mason-lspconfig").setup(config.opts)

  local setup_augroup = vim.api.nvim_create_augroup("_setupLSPConfig", { clear = true })

  augroup = vim.api.nvim_create_augroup("LSPConfig", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", { group = setup_augroup, callback = on_attach })
  vim.api.nvim_create_autocmd("LspDetach", { group = setup_augroup, callback = on_detach })
end

return M
