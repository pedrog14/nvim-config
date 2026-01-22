local M = {}
local cache_extmarks = {} ---@type table<string, vim.api.keyset.set_extmark[]>
local config = require("utils.indent.config")
local ns = nil ---@type integer

---@param indent integer
---@param data   indent.data
local get_extmarks = function(indent, data)
  local key = indent .. ":" .. data.leftcol .. ":" .. data.shiftwidth .. ":" .. (data.breakindent and "bi" or "")

  if cache_extmarks[key] then
    return cache_extmarks[key]
  end

  cache_extmarks[key] = {}

  local shiftwidth = data.shiftwidth
  indent = math.floor(indent / shiftwidth)

  for i = 1, indent do
    local col = (i - 1) * shiftwidth - data.leftcol
    if col >= 0 then
      table.insert(cache_extmarks[key], {
        virt_text = { { config.opts.char, "NonText" } },
        virt_text_pos = "overlay",
        virt_text_win_col = col,
        hl_mode = "combine",
        priority = 1,
        ephemeral = true,
        virt_text_repeat_linebreak = data.breakindent,
      })
    end
  end

  return cache_extmarks[key]
end

local filter = function(bufnr)
  local filter = config.opts.filter
  local filetype, buftype = {}, {}

  for _, value in ipairs(filter.filetype) do
    filetype[value] = true
  end

  for _, value in ipairs(filter.buftype) do
    buftype[value] = true
  end

  local ft, bt = vim.bo[bufnr].filetype, vim.bo[bufnr].buftype

  return not (filetype[ft] or buftype[bt])
end

---@param _      "win"
---@param winid  integer
---@param bufnr  integer
---@param top    integer
---@param bottom integer
local on_win = function(_, winid, bufnr, top, bottom)
  if not filter(bufnr) then
    return
  end

  top = top + 1
  bottom = bottom + 1

  ---@type indent.data?, integer
  local previous, changedtick = M.data[winid], vim.b[bufnr].changedtick

  if not (previous and previous.bufnr == bufnr and previous.changedtick == changedtick) then
    previous = nil
  end

  ---@class indent.data
  local data = {
    changedtick = changedtick,
    current = winid == vim.api.nvim_get_current_win(),
    winid = winid,
    bufnr = bufnr,
    top = top,
    bottom = bottom,
    leftcol = vim.api.nvim_buf_call(bufnr, vim.fn.winsaveview).leftcol, ---@type integer
    shiftwidth = vim.bo[bufnr].shiftwidth,
    indent = previous and previous.indent or { [0] = 0 },
    breakindent = vim.wo[winid].breakindent and vim.wo[winid].wrap,
  }

  local current = data.indent
  data.shiftwidth = data.shiftwidth == 0 and vim.bo[bufnr].tabstop or data.shiftwidth
  M.data[winid] = data

  vim.api.nvim_buf_call(bufnr, function()
    for line = top, bottom do
      local indent = current[line]

      if not indent then
        local prev = vim.fn.prevnonblank(line)
        current[prev] = current[prev] or vim.fn.indent(prev)
        indent = current[prev]

        if prev ~= line then
          local next = vim.fn.nextnonblank(line)
          current[next] = current[next] or vim.fn.indent(next)
          indent = math.max(indent, current[next])
        end

        current[line] = indent
      end

      local extmarks = indent > 0 and get_extmarks(indent, data) or {}

      for _, opts in ipairs(extmarks) do
        vim.api.nvim_buf_set_extmark(bufnr, ns, line - 1, 0, opts)
      end
    end
  end)
end

M.data = {}

---@param opts indent.config?
M.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.default, opts or {})
  ns = vim.api.nvim_create_namespace("indent")

  vim.api.nvim_set_decoration_provider(ns, { on_win = on_win })

  vim.api.nvim_create_autocmd({ "WinClosed", "BufDelete", "BufWipeout" }, {
    callback = function()
      for winid, _ in pairs(M.data) do
        if not vim.api.nvim_win_is_valid(winid) then
          M.data[winid] = nil
        end
      end
    end,
  })
end

return M
