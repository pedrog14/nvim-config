local M = {}

M.setup = function(opts)
    -- if opts.auto_fmts_by_ft then
    --     opts.formatters_by_ft = vim.tbl_deep_extend(
    --         "force",
    --         opts.formatters_by_ft,
    --         require("utils.scripts.gen_formatter_list").auto_fmt_list
    --     )
    -- end
    require("conform").setup(opts)
end

return M
