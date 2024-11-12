local M = {}

M.setup = function(opts)
    require("conform").setup(opts)
    if opts.handlers then
        require("mason-conform").setup_handlers(opts.handlers)
    end
end

return M
