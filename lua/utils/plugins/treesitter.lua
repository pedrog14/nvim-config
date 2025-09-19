local M = {}

M.setup = function(opts)
    local ts = require("nvim-treesitter")

    ts.setup(opts.install_dir and { install_dir = opts.install_dir })

    local ensure_installed = vim.tbl_get(opts, "ensure_installed")
    if ensure_installed then
        require("nvim-treesitter").install(vim.tbl_filter(function(lang)
            local available = vim.list_contains(ts.get_available(), lang)
            return available and not vim.list_contains(ts.get_installed(), lang)
        end, ensure_installed))
    end

    vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true }),
        callback = function(args)
            local ft = args.match
            local buf = args.buf

            local available = vim.list_contains(ts.get_available(), ft)

            if not available then
                return
            end

            -- Auto Install
            if vim.tbl_get(opts, "auto_install") then
                local installed = ts.get_installed()
                if not vim.list_contains(installed, ft) then
                    vim.schedule(function()
                        require("nvim-treesitter").install(ft):wait(300000)
                    end)
                end
            end

            -- Highlight
            if vim.tbl_get(opts, "highlight", "enable") ~= false then
                pcall(vim.treesitter.start)
            end

            -- Folds
            if vim.tbl_get(opts, "folds", "enable") then
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            end

            -- Indent
            if vim.tbl_get(opts, "indent", "enable") then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })
end

return M
