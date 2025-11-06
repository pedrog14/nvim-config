---@class core.keymap: snacks.keymap.set.Opts
---@field [1] string
---@field [2] string|function
---@field mode? string|string[]

local M = {}

---@param keymaps core.keymap[]
M.set = function(keymaps)
    keymaps = keymaps or {}

    local has_snacks, snacks = pcall(require, "snacks")
    local util = has_snacks and snacks or vim

    for _, opts in ipairs(keymaps) do
        local mode = opts.mode
                and (
                    type(opts.mode) == "table" and vim.deepcopy(opts.mode --[[@as string[] ]]) or opts.mode
                )
            or "n"
        opts.mode = nil

        local lhs = table.remove(opts, 1)
        local rhs = table.remove(opts, 1)

        util.keymap.set(mode, lhs, rhs, opts)
    end
end

return M
