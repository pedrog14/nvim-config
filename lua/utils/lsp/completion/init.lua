local M = {}
local config = require("utils.lsp.completion.config")
local result = {} ---@type table[]

---@param item lsp.CompletionItem
---@return vim.v.completed_item
local convert = function(item)
  local kind = vim.lsp.protocol.CompletionItemKind[item.kind]

  local icon = vim.tbl_get(config, "opts", "icons", "symbols", kind) ---@type string

  ---@type vim.v.completed_item
  return { kind = ("%s %s"):format(icon, kind), kind_hlgroup = "LspKind" .. kind }
end

---@param attach_args vim.api.keyset.create_autocmd.callback_args
local on_attach = vim.schedule_wrap(function(attach_args)
  local bufnr = attach_args.buf

  local client_id = vim.tbl_get(attach_args, "data", "client_id")
  if not client_id then
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not (client and client:supports_method("textDocument/completion", bufnr)) then
    return
  end

  vim.lsp.completion.enable(true, client_id, bufnr, { convert = convert })

  vim.keymap.set("i", "<c-space>", function()
    vim.lsp.completion.get()
  end, { buffer = bufnr, desc = "Trigger Completion" })

  local req = nil

  local change_doc = function()
    local info = vim.fn.complete_info({ "selected" })
    local selected = info["selected"]
    if selected == -1 then
      return
    end

    local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
    if not completion_item then
      return
    end

    local set_doc = function()
      local doc = vim.tbl_get(result, selected, "documentation")
      if not doc then
        return
      end

      ---@type { winid: integer?, bufnr: integer? }
      local info_data = vim.api.nvim__complete_set(selected, { info = doc.value })

      if
        info_data.winid
        and vim.api.nvim_win_is_valid(info_data.winid)
        and info_data.bufnr
        and vim.api.nvim_buf_is_valid(info_data.bufnr)
        and doc.kind == vim.lsp.protocol.MarkupKind.Markdown
      then
        vim.bo[info_data.bufnr].filetype = "markdown"
        vim.wo[info_data.winid].conceallevel = 2
      end
    end

    ---@type lsp.Handler
    local handler = function(err, res)
      if err or not res then
        return
      end

      result[selected] = res

      set_doc()
    end

    if not result[selected] then
      if req then
        client:cancel_request(req)
      end

      _, req = client:request("completionItem/resolve", completion_item, handler, bufnr)
    else
      set_doc()
    end
  end

  vim.api.nvim_create_autocmd("CompleteChanged", { buffer = bufnr, callback = change_doc })

  vim.api.nvim_create_autocmd("CompleteDone", {
    buffer = bufnr,
    callback = function()
      result = {}
    end,
  })
end)

M.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.default, opts or {})

  local setup_augroup = vim.api.nvim_create_augroup("_setupLspCompletion", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", { group = setup_augroup, callback = on_attach })
end

return M
