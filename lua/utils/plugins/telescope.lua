local M = {}

M.load_extensions = function(extensions)
    for _, extension in ipairs(extensions) do
        require("telescope").load_extension(extension)
    end
end

M.setup = function(opts)
    require("telescope").setup(opts)
    if opts.load_extensions then
        M.load_extensions(opts.load_extensions)
    end
end

return M
