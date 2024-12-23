---@class utils.plugins.snacks
local M = {}

local notify_lsp_progress = function()
    ---@type table<number, { token: lsp.ProgressToken, msg: string, done: boolean }[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
            if not client or type(value) ~= "table" then
                return
            end
            local p = progress[client.id]

            for i = 1, #p + 1 do
                if i == #p + 1 or p[i].token == ev.data.params.token then
                    p[i] = {
                        token = ev.data.params.token,
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

            local spinner = {
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
            }
            vim.notify(table.concat(msg, "\n"), "info", {
                id = "lsp_progress",
                title = client.name,
                opts = function(notif)
                    notif.icon = #progress[client.id] == 0 and ""
                        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end,
            })
        end,
    })
end

---@param filter? { filetype: string[] }
---@return fun(bufnr: number): boolean
local set_indent_filter = function(filter)
    local exclude = nil
    filter = filter or {}

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

    -- Generate a filter function (indent)
    local indent = opts.indent or {}
    if indent.filter then
        local filter = indent.filter
        indent.filter = type(filter) == "table" and set_indent_filter(filter) or filter
    end

    require("snacks").setup(opts)

    -- Enable LSP progress notification
    local notifier = opts.notifier or {}
    if notifier.notify_lsp_progress then
        notify_lsp_progress()
    end

    -- Create LazyGit user command
    local lazygit = Snacks.lazygit
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
