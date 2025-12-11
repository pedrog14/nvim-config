---@class core.autocmd: vim.api.keyset.create_autocmd
---@field event vim.api.keyset.events|vim.api.keyset.events[]

local M = {}

---@param autocmds core.autocmd[]
M.set = function(autocmds)
    autocmds = autocmds or {}

    for _, opts in ipairs(autocmds) do
        local event = type(opts.event) == "table" and vim.deepcopy(opts.event --[[@as string[] ]])
            or opts.event
        opts.event = nil

        vim.api.nvim_create_autocmd(event, opts)
    end
end

return M
