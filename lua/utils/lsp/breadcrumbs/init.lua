---@alias range.Position { line: integer, character: integer }

---@class range.Data
---@field start range.Position
---@field end   range.Position

local M = {}
local result = {} ---@type table[]
local augroup = nil ---@type integer?
local breadcrumbs = nil ---@type string?
local config = require("utils.lsp.breadcrumbs.config")

---@param range range.Data
---@param row   integer
---@param col   integer
---@return boolean
local range_contains_pos = function(range, row, col)
  local start = range.start
  local stop = range["end"]

  return not (
    (row < start.line or row > stop.line)
    or (row == start.line and col < start.character)
    or (row == stop.line and col > stop.character)
  )
end

---@param res table
---@param row integer
---@param col integer
---@return string
local breadcrumbs_str = function(res, row, col)
  if not res then
    return ""
  end

  ---@type table?
  local result_ref = res
  local path = {}

  while result_ref do
    local sym = nil ---@type table?

    for _, s in ipairs(result_ref) do
      if s.range and range_contains_pos(s.range, row, col) then
        local kind = vim.lsp.protocol.SymbolKind[s.kind]
        local icon = vim.tbl_get(config, "opts", "icons", "symbols", kind) ---@type string

        path[#path + 1] = ("%s %s"):format(icon, s.name)
        sym = s.children
        break
      end
    end

    result_ref = sym
  end

  local sep = vim.tbl_get(config, "opts", "icons", "separator") ---@type string
  local max_size = vim.api.nvim_get_option_value("co", {}) - 94 ---@type integer TODO: Better way to calculate free space in statusline
  local ret = ""

  for i = #path, 1, -1 do
    local sym = path[i]
    local temp = i == #path and sym or ("%s %s %s"):format(sym, sep, ret)

    if #temp < max_size then
      ret = temp
    else
      sym = vim.tbl_get(config, "opts", "icons", "ellipsis") ---@type string
      ret = i == #path and sym or ("%s %s %s"):format(sym, sep, ret)
      break
    end
  end

  return ret
end

---@param args vim.api.keyset.create_autocmd.callback_args
local on_attach = vim.schedule_wrap(function(args)
  local bufnr = vim._resolve_bufnr(args.buf)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local winnr = vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(winnr) then
    return
  end

  local client_id = vim.tbl_get(args, "data", "client_id")
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

  ---@type integer?
  local req = nil
  local params = { textDocument = { uri = uri } }

  ---@param req_limit integer? Maximum number of recursions; ~30 requests/second; default: 60
  local function update_result(req_limit)
    req_limit = req_limit or 60

    -- Cancel old request if it takes too long 🎃 and another request needs to be called
    if req then
      client:cancel_request(req)
    end

    _, req = client:request("textDocument/documentSymbol", params, function(err, res)
      if err or not res then
        if req_limit ~= 0 then
          vim.defer_fn(function()
            update_result(req_limit - 1)
          end, 33)
        end

        return
      end

      result[bufnr] = res
    end, bufnr)
  end

  local update_str = function()
    local cursor = vim.api.nvim_win_get_cursor(winnr)
    local row, col = cursor[1] - 1, cursor[2]

    breadcrumbs = breadcrumbs_str(result[bufnr], row, col)
  end

  update_result()
  update_str()

  vim.api.nvim_create_autocmd({ "BufModifiedSet", "TextChanged", "FileChangedShellPost", "InsertLeave" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      update_result()
    end,
  })

  vim.api.nvim_create_autocmd({ "WinResized", "CursorMoved" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      update_str()
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      local win = vim.api.nvim_get_current_win()

      if vim.api.nvim_win_is_valid(win) then
        winnr = win -- Updating current buffer window
      end
    end,
  })
end)

---@param args vim.api.keyset.create_autocmd.callback_args
local on_detach = vim.schedule_wrap(function(args)
  local bufnr = vim._resolve_bufnr(args.buf)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  result[bufnr] = nil
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
end)

---@param opts utils.lsp.breadcrumbs.Opts?
M.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.default, opts or {})
  augroup = vim.api.nvim_create_augroup("LspBreadcrumbs", { clear = true })

  local setup_augroup = vim.api.nvim_create_augroup("_setupLspBreadcrumbs", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", { group = setup_augroup, callback = on_attach })
  vim.api.nvim_create_autocmd("LspDetach", { group = setup_augroup, callback = on_detach })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = setup_augroup,
    callback = function(args)
      local bufnr = vim._resolve_bufnr(args.buf)
      local winnr = vim.api.nvim_get_current_win()

      if
        not (vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_win_is_valid(winnr))
        or vim.api.nvim_get_option_value("ft", { buf = bufnr }) == "help"
        or vim.fn.win_gettype(winnr) ~= ""
        or vim.tbl_isempty(vim.lsp.get_clients({
          bufnr = bufnr,
          method = "textDocument/documentSymbol",
        }))
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
