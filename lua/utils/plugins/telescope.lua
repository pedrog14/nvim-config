local M = {}

M.setup = function(opts)
    require("telescope").setup(opts)
    if opts.load_extensions then
        for _, extension in ipairs(opts.load_extensions) do
            require("telescope").load_extension(extension)
        end
    end
end

return M
