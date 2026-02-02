---@alias utils.treesitter.EnabledOpts { enabled: boolean, exclude: string[] }

---@class utils.treesitter.check_enabled.callback.Data
---@field lang  string
---@field query utils.treesitter.QueryType
---@field bufnr integer

---@class utils.treesitter.check_enabled.Data: utils.treesitter.check_enabled.callback.Data
---@field callback fun(data: utils.treesitter.check_enabled.callback.Data): any

local M = {}
local treesitter = require("nvim-treesitter")
local utils = require("utils.treesitter")

---@param field string
---@param data utils.treesitter.check_enabled.Data
---@return any
local check_enabled = function(field, data)
  ---@type utils.treesitter.EnabledOpts
  local option = vim.tbl_get(M.config, "opts", field) or {}
  local exclude = option.exclude or {}
  return option.enabled
    and not vim.tbl_contains(exclude, data.lang)
    and utils.get_query(data.lang, data.query)
    and data:callback()
end

---@param args vim.api.keyset.create_autocmd.callback_args
local on_filetype = function(args)
  local bufnr, lang = args.buf, vim.treesitter.language.get_lang(args.match)
  if not lang then
    return
  end

  local is_installed = utils.get_installed(lang)
  if not is_installed then
    return
  end

  check_enabled("highlight", {
    lang = lang,
    query = "highlights",
    bufnr = bufnr,
    callback = function(data)
      vim.treesitter.start(data.bufnr, data.lang)
    end,
  })

  check_enabled("indent", {
    lang = lang,
    query = "indents",
    bufnr = bufnr,
    callback = function(data)
      vim.bo[data.bufnr].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    end,
  })

  check_enabled("fold", {
    lang = lang,
    query = "folds",
    bufnr = bufnr,
    callback = function()
      local winid = vim.api.nvim_get_current_win()
      vim.wo[winid].foldmethod = "expr"
      vim.wo[winid].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  })
end

-- stylua: ignore
M.config = {
  ---@class utils.treesitter.Opts
  ---@field install_dir string?
  ---
  ---@field ensure_installed string[]?
  ---
  ---@field fold      utils.treesitter.EnabledOpts?
  ---@field highlight utils.treesitter.EnabledOpts?
  ---@field indent    utils.treesitter.EnabledOpts?
  default = {
    fold      = { enabled = true },
    highlight = { enabled = true },
    indent    = { enabled = true },
  },

  opts = nil, ---@type utils.treesitter.Opts?
}

---@param opts utils.treesitter.Opts
M.setup = function(opts)
  M.config.opts = vim.tbl_deep_extend("force", M.config.default, opts or {})

  treesitter.setup(M.config.opts)
  utils.get_installed(nil, { update = true })

  ---@type string[]?
  local ensure_installed = vim.tbl_get(M.config, "opts", "ensure_installed")
  if ensure_installed then
    local install = vim.tbl_filter(function(lang)
      return not utils.get_installed(lang)
    end, ensure_installed)

    if #install > 0 then
      treesitter.install(install, { summary = true }):await(function()
        utils.get_installed(nil, { update = true })
      end)
    end
  end

  local setup_augroup = vim.api.nvim_create_augroup("_setupTSConfig", { clear = true })

  vim.api.nvim_create_autocmd("FileType", { group = setup_augroup, callback = on_filetype })

  local cmd_args = vim.api.nvim_get_commands({})
  local tsinstall_args = vim.tbl_get(cmd_args, "TSInstall")
  local tsuninstall_args = vim.tbl_get(cmd_args, "TSUninstall")

  vim.api.nvim_del_user_command("TSInstall")
  vim.api.nvim_del_user_command("TSUninstall")

  vim.api.nvim_create_user_command("TSInstall", function(args)
    treesitter.install(args.fargs, { force = args.bang, summary = true }):await(function()
      utils.get_installed(nil, { update = true })

      local pattern = {}
      for _, lang in ipairs(args.fargs) do
        local filetypes = vim.treesitter.language.get_filetypes(lang)
        for _, ft in ipairs(filetypes) do
          pattern[ft] = true
        end
      end
      pattern = vim.tbl_keys(pattern)

      vim.api.nvim_exec_autocmds("FileType", { group = setup_augroup, pattern = pattern })
    end)
  end, {
    bang = tsinstall_args.bang,
    bar = tsinstall_args.bar,
    complete = tsinstall_args.complete,
    desc = tsinstall_args.definition,
    nargs = tsinstall_args.nargs,
  })

  vim.api.nvim_create_user_command("TSUninstall", function(args)
    treesitter.uninstall(args.fargs, { summary = true }):await(function()
      utils.get_installed(nil, { update = true })
    end)
  end, {
    bar = tsuninstall_args.bar,
    complete = tsuninstall_args.complete,
    desc = tsuninstall_args.definition,
    nargs = tsuninstall_args.nargs,
  })
end

return M
