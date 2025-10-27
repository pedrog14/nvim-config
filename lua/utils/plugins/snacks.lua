local snacks = require("snacks")

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

---@param icons? { spinner?: string[], check?: string }
local lsp_progress = function(icons)
    icons = icons or {}

    ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd("LspProgress", {
        ---@param args {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local value = args.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
            if not client or type(value) ~= "table" then
                return
            end
            local p = progress[client.id]

            for i = 1, #p + 1 do
                if i == #p + 1 or p[i].token == args.data.params.token then
                    p[i] = {
                        token = args.data.params.token,
                        msg = ("[%3d%%] %s%s"):format(
                            value.kind == "end" and 100 or value.percentage or 100,
                            value.title or "",
                            value.message and (" **%s**"):format(value.message) or ""
                        ),
                        done = value.kind == "end",
                    }
                    break
                end
            end

            local msg = {} ---@type string[]
            progress[client.id] = vim.tbl_filter(function(v)
                return table.insert(msg, v.msg) or not v.done
            end, p)

            local spinner = icons.spinner or { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            local check = icons.check or "󰄬 "
            vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
                id = "lsp_progress",
                title = client.name,
                opts = function(notif)
                    notif.icon = #progress[client.id] == 0 and check
                        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end,
            })
        end,
    })
end

---@module "snacks"
---@param opts snacks.Config
M.setup = function(opts)
    opts = opts or {}

    ---@type { filter?: { filetype: string[] } | fun(bufnr: number): boolean }
    local indent = opts.indent or {}
    if indent.filter and type(indent.filter) == "table" then
        indent.filter = gen_filter(indent.filter --[[@as { filetype: string[] }]])
    end

    snacks.setup(opts)

    if vim.tbl_get(opts, "notifier", "lsp", "enabled") ~= false then
        local icons = vim.tbl_get(opts, "notifier", "lsp", "icons")
        lsp_progress(icons)
    end

    local lazygit = snacks.lazygit
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
