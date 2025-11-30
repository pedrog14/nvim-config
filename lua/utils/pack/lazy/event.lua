local M = {}

local pack = require("utils.pack")

---@param event vim.api.keyset.events|vim.api.keyset.events[]
---@param spec utils.pack.SpecResolved
M.load = function(event, spec)
    vim.api.nvim_create_autocmd(event, {
        once = true,
        callback = vim.schedule_wrap(function()
            pack.load(spec)
        end),
    })
end

return M
