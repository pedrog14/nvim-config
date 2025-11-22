---@alias utils.snacks.indent snacks.indent.Config|{ filter: { exclude: string[] }? }

---@class utils.snacks.opts: snacks.Config
---@field indent? utils.snacks.indent

local M = {}

---@param exclude string[]
---@return fun(buf: number): boolean
local gen_filter = function(exclude)
    return function(buf)
        return not vim.tbl_contains(exclude, vim.api.nvim_get_option_value("filetype", { buf = buf }))
            and vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
    end
end

---@module "snacks"
---@param opts utils.snacks.opts
M.setup = function(opts)
    opts = opts or {}

    ---@type { exclude: string[] }|fun(buf: number, win: number): boolean
    local filter = vim.tbl_get(opts, "indent", "filter")
    filter = type(filter) == "table" and gen_filter(filter.exclude --[[@as string[] ]]) or filter
    opts.indent = filter and vim.tbl_deep_extend("force", opts.indent, { filter = filter }) or opts.indent

    local snacks = require("snacks")
    snacks.setup(opts)

    local lazygit = snacks.lazygit
    vim.api.nvim_create_user_command("LazyGit", function(args)
        if vim.tbl_contains(vim.tbl_keys(lazygit), args.args) then
            lazygit[args.args]()
        elseif args.args == "" then
            lazygit()
        end
    end, {
        nargs = "*",
        desc = "Open LazyGit",
        complete = function()
            local completion = {}
            for key, _ in pairs(lazygit) do
                if not (key == "health" or key == "meta") then
                    completion[#completion + 1] = key
                end
            end
            return completion
        end,
    })
end

return M
