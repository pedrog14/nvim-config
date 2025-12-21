---@class range.Data
---@field start range.pos
---@field end   range.pos

---@class range.pos
---@field line      integer
---@field character integer

---@class breadcrumbs.Data
---@field result table[]?
---@field str    string?

local M = {}

local breadcrumbs = nil ---@type string?

local config = require("utils.lsp.breadcrumbs.config")

---@param range range.Data
---@param row   integer
---@param col   integer
local range_contains_pos = function(range, row, col)
  local start = range.start
  local stop = range["end"]

  if row < start.line or row > stop.line then
    return false
  end

  if row == start.line and col < start.character then
    return false
  end

  if row == stop.line and col > stop.character then
    return false
  end

  return true
end

---@param result table
---@param row    integer
---@param col    integer
---@param sep    string
---@return string?
local breadcrumbs_str = function(result, row, col, sep)
  if not result then
    return
  end

  local path = {}

  ---@type table?
  local result_ref = result

  while result_ref do
    local symbol = nil
    for _, s in ipairs(result_ref) do
      if s.range and range_contains_pos(s.range, row, col) then
        symbol = s
        break
      end
    end
    if symbol then
      local kind = vim.lsp.protocol.SymbolKind[symbol.kind]
      local icon = config.opts.icons.symbols[kind]
      path[#path + 1] = ("%s %s"):format(icon, symbol.name)
    end
    result_ref = symbol and symbol.children
  end

  local ret = path[#path]

  for i = #path - 1, 1, -1 do
    ret = ("%s %s %s"):format(path[i], sep, ret)
    if #ret >= 96 and i ~= 1 then
      ret = ("%s %s %s"):format("…", sep, ret)
      break
    end
  end

  return ret
end

local augroup = nil ---@type number?

---@param attach_args vim.api.keyset.create_autocmd.callback_args
local on_attach = vim.schedule_wrap(function(attach_args)
  local bufnr = vim._resolve_bufnr(attach_args.buf)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local winnr = vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(winnr) then
    return
  end

  local client_id = vim.tbl_get(attach_args, "data", "client_id")
  if not client_id then
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not (client and client:supports_method("textDocument/documentSymbol")) then
    return
  end

  local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
  if stat and stat.size > 1024 * 1024 then
    return
  end

  local uri = vim.uri_from_bufnr(bufnr)
  if not uri or vim.split(uri, ":")[1] ~= "file" then
    return
  end

  local params = { textDocument = { uri = uri } }

  M.data[bufnr] = {}

  local req = nil

  local req_limit = 61 -- Max number of recursions; ~2 seconds max time
  local function update_result(limit)
    ---@type lsp.Handler
    local handler = function(err, result)
      if err or not result then
        if limit ~= 0 then
          vim.defer_fn(function()
            update_result(limit - 1)
          end, 33)
        end
        return
      end
      M.data[bufnr].result = result
    end

    _, req = client:request("textDocument/documentSymbol", params, handler, bufnr)
  end

  local update_breadcrumbs = function()
    local cursor = vim.api.nvim_win_get_cursor(winnr)
    local row, col = cursor[1] - 1, cursor[2]

    M.data[bufnr].str = breadcrumbs_str(M.data[bufnr].result, row, col, config.opts.icons.separator)
  end

  update_result(req_limit)
  update_breadcrumbs()
  breadcrumbs = M.data[bufnr].str

  vim.api.nvim_create_autocmd({ "BufModifiedSet", "TextChanged", "FileChangedShellPost", "ModeChanged" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      -- Cancel old request if it takes too long 🎃 and another request needs to be called
      pcall(client.cancel_request, client, req)
      update_result(req_limit)
    end,
  })

  vim.api.nvim_create_autocmd({ "WinResized", "CursorMoved" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      update_breadcrumbs()
      breadcrumbs = M.data[bufnr].str
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_is_valid(win) then
        winnr = win -- Updating buffer window
      end
      update_breadcrumbs()
      breadcrumbs = M.data[bufnr].str
    end,
  })
end)

---@param args vim.api.keyset.create_autocmd.callback_args
local on_detach = vim.schedule_wrap(function(args)
  local bufnr = args.buf
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  M.data[bufnr] = nil
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
end)

M.data = {} ---@type breadcrumbs.Data[]

---@param opts utils.lsp.breadcrumbs.opts?
M.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.default, opts or {})

  local setup_augroup = vim.api.nvim_create_augroup("_setupLspBreadcrumbs", { clear = true })
  augroup = vim.api.nvim_create_augroup("LspBreadcrumbs", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", { group = setup_augroup, callback = on_attach })

  vim.api.nvim_create_autocmd("LspDetach", { group = setup_augroup, callback = on_detach })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWritePost" }, {
    group = setup_augroup,
    callback = function(args)
      local bufnr = vim._resolve_bufnr(args.buf)
      if
        not vim.api.nvim_buf_is_valid(bufnr)
        or vim.tbl_isempty(vim.lsp.get_clients({ method = "textDocument/documentSymbol", bufnr = bufnr }))
      then
        breadcrumbs = nil
      end
    end,
  })
end

M.get = function()
  return breadcrumbs or ""
end

return M
