---@class utils.plugins.snacks
local M = {}

---@param filter { filetype: string[] }
---@return fun(bufnr: number): boolean
local gen_filter = function(filter)
    local exclude = nil

    if filter.filetype then
        exclude = {}
        for _, filetype in ipairs(filter.filetype) do
            exclude[filetype] = true
        end
    end

    return function(bufnr)
        return not (exclude and exclude[vim.bo[bufnr].filetype])
            and vim.g.snacks_indent ~= false
            and vim.b[bufnr].snacks_indent ~= false
            and vim.bo[bufnr].buftype == ""
    end
end

M.setup = function(opts)
    opts = opts or {}

    ---@type { filter?: { filetype: string[] } | fun(bufnr: number): boolean }
    local indent = opts.indent or {}
    if indent.filter and type(indent.filter) == "table" then
        indent.filter = gen_filter(indent.filter --[[@as { filetype: string[] }]])
    end

    require("snacks").setup(opts)

    local lazygit = require("snacks").lazygit
    vim.api.nvim_create_user_command("LazyGit", function(args)
        for key, _ in pairs(lazygit) do
            if args.args == key then
                lazygit[key]()
            end
        end
        if args.args == "" then
            lazygit()
        end
    end, {
        nargs = "*",
        desc = "Open LazyGit",
        complete = function()
            local completion = {}
            for key, _ in pairs(lazygit) do
                if key ~= "health" and key ~= "meta" then
                    completion[#completion + 1] = key
                end
            end
            return completion
        end,
    })
end

return M
