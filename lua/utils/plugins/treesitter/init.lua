---@class utils.treesitter.EnabledOpts
---@field enabled boolean?
---@field exclude string[]?

---@class utils.treesitter.Opts: TSConfig
---@field install_dir      string?
---@field ensure_installed string[]?
---@field fold             utils.treesitter.EnabledOpts?
---@field highlight        utils.treesitter.EnabledOpts?
---@field indent           utils.treesitter.EnabledOpts?

---@class utils.treesitter.check_enabled.callback.Data
---@field lang    string
---@field query   utils.treesitter.QueryType
---@field bufnr   number?
---@field default boolean?

---@class utils.treesitter.check_enabled.Data: utils.treesitter.check_enabled.callback.Data
---@field callback fun(data: utils.treesitter.check_enabled.callback.Data)

local M = {}

---@param opts utils.treesitter.Opts
M.setup = function(opts)
  opts = opts or {}

  local treesitter = require("nvim-treesitter")
  local utils = require("utils.treesitter")

  treesitter.setup(opts)

  utils.get_installed(nil, { update = true })

  local install = vim.tbl_filter(function(lang)
    return not utils.get_installed(lang)
  end, opts.ensure_installed or {})

  if #install > 0 then
    treesitter.install(install, { summary = true }):await(function()
      utils.get_installed(nil, { update = true })
    end)
  end

  ---@param field string
  ---@param data utils.treesitter.check_enabled.Data
  ---@return any
  local check_enabled = function(field, data)
    local option = opts[field] or {} ---@type { enabled: boolean, exclude: string[] }
    local exclude = option.exclude or {}
    return (option.enabled == nil and data.default or option.enabled)
      and not vim.tbl_contains(exclude, data.lang)
      and utils.get_query(data.lang, data.query)
      and (data:callback() or true)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TSConfig", { clear = true }),
    callback = function(args)
      local bufnr = vim._resolve_bufnr(args.buf)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      local lang = vim.treesitter.language.get_lang(args.match)
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
        default = true,
        callback = function(data)
          vim.treesitter.start(data.bufnr, data.lang)
        end,
      })

      check_enabled("indent", {
        lang = lang,
        query = "indents",
        bufnr = bufnr,
        default = true,
        callback = function(data)
          vim.api.nvim_set_option_value(
            "indentexpr",
            "v:lua.require('nvim-treesitter').indentexpr()",
            { buf = data.bufnr }
          )
        end,
      })

      check_enabled("fold", {
        lang = lang,
        query = "folds",
        bufnr = bufnr,
        default = true,
        callback = function()
          local winnr = vim.api.nvim_get_current_win()
          if not vim.api.nvim_win_is_valid(winnr) then
            return
          end

          vim.api.nvim_set_option_value("foldmethod", "expr", { win = winnr })
          vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { win = winnr })
        end,
      })
    end,
  })

  local cmd_args = vim.api.nvim_get_commands({})

  local tsinstall_args = vim.tbl_get(cmd_args, "TSInstall")
  vim.api.nvim_del_user_command("TSInstall")
  vim.api.nvim_create_user_command("TSInstall", function(args)
    treesitter.install(args.fargs, { force = args.bang, summary = true }):await(function()
      utils.get_installed(nil, { update = true })
      vim.api.nvim_exec_autocmds("FileType", { group = vim.api.nvim_create_augroup("TSConfig", { clear = false }) })
    end)
  end, {
    nargs = tsinstall_args.nargs,
    bang = tsinstall_args.bang,
    bar = tsinstall_args.bar,
    complete = tsinstall_args.complete,
    desc = tsinstall_args.definition,
  })

  local tsuninstall_args = vim.tbl_get(cmd_args, "TSUninstall")
  vim.api.nvim_del_user_command("TSUninstall")
  vim.api.nvim_create_user_command("TSUninstall", function(args)
    treesitter.uninstall(args.fargs, { summary = true }):await(function()
      utils.get_installed(nil, { update = true })
    end)
  end, {
    nargs = tsuninstall_args.nargs,
    bar = tsuninstall_args.bar,
    complete = tsuninstall_args.complete,
    desc = tsuninstall_args.definition,
  })
end

return M
