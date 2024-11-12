local M = {}

M.setup = function(opts)
    if opts.handlers then
        require("mason-conform").setup_handlers(opts.handlers)
    end
    require("conform").setup(opts)
end

return M
