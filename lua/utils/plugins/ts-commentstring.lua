local M = {}

M.setup = function(opts)
    local get_option = vim.filetype.get_option

    require("ts_context_commentstring").setup(opts)

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
            or get_option(filetype, option)
    end
end

return M
