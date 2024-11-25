local M = {}

M.setup = function(opts)
    require("conform").setup(opts)
    require("mason-conform").setup_handlers(opts.handlers)
end

return M
