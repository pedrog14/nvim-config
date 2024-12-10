---@class utils.plugins.telescope
local M = {}

M.setup = function(opts)
    require("telescope").setup(opts)
    if opts.extensions then
        for extension, _ in pairs(opts.extensions) do
            require("telescope").load_extension(extension)
        end
    end
end

return M
