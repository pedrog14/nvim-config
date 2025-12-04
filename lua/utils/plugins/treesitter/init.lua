---@class utils.treesitter.opts
---@field ensure_installed? string[]
---@field highlight? { enabled: boolean, exclude: string[] }
---@field fold? { enabled: boolean, exclude: string[] }
---@field indent? { enabled: boolean, exclude: string[] }

local M = {}

---@param opts utils.treesitter.opts
M.setup = function(opts)
    local treesitter = require("nvim-treesitter")
    local utils = require("utils.treesitter")

    treesitter.setup(opts)

    utils.get_installed({ update = true })

    local install = vim.tbl_filter(function(lang)
        return not utils.get_installed()[lang]
    end, opts.ensure_installed or {})

    if #install > 0 then
        treesitter.install(install, { summary = true }):await(function()
            utils.get_installed({ update = true })
        end)
    end

    ---@param field string
    ---@param data { lang: string, query: string, default: boolean }
    ---@return boolean
    local is_enabled = function(field, data)
        local opt = opts[field] or {} ---@type { enabled: boolean, exclude: string[] }
        local exclude = opt.exclude or {}
        return (opt.enabled ~= nil and opt.enabled or data.default)
            and not vim.tbl_contains(exclude, data.lang)
            and utils.get_query(data.lang, data.query) --[[@as boolean]]
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TSConfig", { clear = true }),
        callback = function(args)
            local bufnr = args.buf
            local lang = vim.treesitter.language.get_lang(args.match)
            local is_installed = lang and utils.get_installed()[lang]

            if not is_installed then
                return
            end

            if
                is_enabled("highlight", {
                    lang = lang --[[@as string]],
                    query = "highlights",
                    default = true,
                })
            then
                pcall(vim.treesitter.start, bufnr, lang)
            end

            if
                is_enabled("indent", {
                    lang = lang --[[@as string]],
                    query = "indents",
                    default = true,
                })
            then
                vim.api.nvim_set_option_value(
                    "indentexpr",
                    "v:lua.require('nvim-treesitter').indentexpr()",
                    { buf = bufnr }
                )
            end

            if
                is_enabled("fold", {
                    lang = lang --[[@as string]],
                    query = "folds",
                    default = true,
                })
            then
                local win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
                vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { win = win })
            end
        end,
    })

    local cmd_opts = vim.tbl_get(vim.api.nvim_get_commands({}), "TSInstall")
    vim.api.nvim_del_user_command("TSInstall")
    vim.api.nvim_create_user_command("TSInstall", function(args)
        treesitter.install(args.fargs, { force = args.bang, summary = true }):await(function()
            utils.get_installed({ update = true })
            vim.api.nvim_exec_autocmds(
                "FileType",
                { group = vim.api.nvim_create_augroup("TSConfig", { clear = false }) }
            )
        end)
    end, {
        nargs = cmd_opts.nargs,
        bang = cmd_opts.bang,
        bar = cmd_opts.bar,
        complete = cmd_opts.complete,
        desc = cmd_opts.definition,
    })

    cmd_opts = vim.tbl_get(vim.api.nvim_get_commands({}), "TSUninstall")
    vim.api.nvim_del_user_command("TSUninstall")
    vim.api.nvim_create_user_command("TSUninstall", function(args)
        treesitter.uninstall(args.fargs, { summary = true }):await(function()
            utils.get_installed({ update = true })
        end)
    end, {
        nargs = cmd_opts.nargs,
        bar = cmd_opts.bar,
        complete = cmd_opts.complete,
        desc = cmd_opts.definition,
    })
end

return M
