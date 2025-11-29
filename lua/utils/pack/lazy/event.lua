local M = {}

local pack = require("utils.pack")

M.load = function(event, spec)
    vim.api.nvim_create_autocmd(event, {
        once = true,
        callback = vim.schedule_wrap(function()
            pack.load(spec)
        end),
    })
end

return M
