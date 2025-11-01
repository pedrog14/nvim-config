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

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_config", { clear = true }),
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match)

            if not (lang and utils.get_available()[lang]) then
                return
            end

            if not utils.get_installed({ update = true })[lang] then
                return
            end

            if vim.tbl_get(opts, "highlight", "enable") ~= false and utils.get_query(lang, "highlights") then
                pcall(vim.treesitter.start, args.buf)
            end

            if vim.tbl_get(opts, "fold", "enable") and utils.get_query(lang, "folds") then
                local win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
                vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { win = win })
            end

            if vim.tbl_get(opts, "indent", "enable") and utils.get_query(lang, "indents") then
                vim.api.nvim_set_option_value(
                    "indentexpr",
                    "v:lua.require'nvim-treesitter'.indentexpr()",
                    { buf = args.buf }
                )
            end
        end,
    })
end

return M
