---@class utils.plugins.treesitter
---@field ensure_installed? string[]
---@field highlight? {enabled: boolean, exclude: string[]}
---@field fold? {enabled: boolean, exclude: string[]}
---@field indent? {enabled: boolean, exclude: string[]}

local M = {}

M.setup = function(opts)
    local treesitter = require("nvim-treesitter")
    local utils = require("utils.treesitter")

    treesitter.setup(opts)

    utils.get_available({ update = true })
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
    ---@param data {lang: string, query: string}
    ---@return boolean
    local is_enabled = function(field, data)
        local option = opts[field] or {}
        local exclude = option.exclude or {}
        return option.enabled ~= false
            and utils.get_query(data.lang, data.query)
            and not vim.tbl_contains(exclude, data.lang)
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_config", { clear = true }),
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match)

            if not (lang and utils.get_installed({ update = true })[lang]) then
                return
            end

            if is_enabled("highlight", { lang = lang, query = "highlights" }) then
                pcall(vim.treesitter.start, args.buf)
            end

            if is_enabled("indent", { lang = lang, query = "indents" }) then
                vim.api.nvim_set_option_value(
                    "indentexpr",
                    "v:lua.require('nvim-treesitter').indentexpr()",
                    { buf = args.buf }
                )
            end

            if is_enabled("fold", { lang = lang, query = "folds" }) then
                local win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
                vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { win = win })
            end
        end,
    })
end

return M
