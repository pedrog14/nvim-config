---@class core.keymap
---@field [1] string|string[]
---@field [2] string
---@field [3] string|function
---@field [4]? snacks.keymap.set.Opts

local M = {}

---@param keymaps core.keymap[]
M.set = function(keymaps)
    for _, key in ipairs(keymaps) do
        (Snacks or vim).keymap.set(key[1], key[2], key[3], key[4])
    end
end

return M
