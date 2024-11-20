local M = {}

---@param item vim.CompletedItem
---@return vim.CompletedItem
M.format_cmp = function(_, item)
    local icons = require("utils.icons").mini("lsp")
    local kind = item.kind:lower()

    if icons[kind] then
        item.kind = icons[kind] .. item.kind
    end

    return item
end

---@alias Placeholder { n: number, text: string }

---@param snippet string
---@param fn fun(placeholder:Placeholder):string
---@return string
M.snippet_replace = function(snippet, fn)
    return snippet:gsub("%$%b{}", function(m)
        local n, name = m:match("^%${(%d+):(.+)}$")
        return n and fn({ n = n, text = name }) or m
    end) or snippet
end

---@param snippet string
---@return string
M.snippet_preview = function(snippet)
    local ok, parsed = pcall(function()
        return vim.lsp._snippet_grammar.parse(snippet)
    end)
    return ok and tostring(parsed)
        or M.snippet_replace(snippet, function(placeholder)
            return M.snippet_preview(placeholder.text)
        end):gsub("%$0", "")
end

M.snippet_fix = function(snippet)
    local texts = {} ---@type table<number, string>
    return M.snippet_replace(snippet, function(placeholder)
        texts[placeholder.n] = texts[placeholder.n] or M.snippet_preview(placeholder.text)
        return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
    end)
end

---@param entry cmp.Entry
M.auto_brackets = function(entry)
    local _cmp = require("cmp")
    local Kind = _cmp.lsp.CompletionItemKind
    local item = entry.completion_item
    if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
        local cursor = vim.api.nvim_win_get_cursor(0)
        local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
        if prev_char ~= "(" and prev_char ~= ")" then
            local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
            vim.api.nvim_feedkeys(keys, "i", true)
        end
    end
end

M.expand = function(snippet)
    -- Native sessions don't support nested snippet sessions.
    -- Always use the top-level session.
    -- Otherwise, when on the first placeholder and selecting a new completion,
    -- the nested session will be used instead of the top-level session.
    -- See: https://github.com/LazyVim/LazyVim/issues/3199
    local session = vim.snippet.active() and vim.snippet._session or nil

    local ok, err = pcall(vim.snippet.expand, snippet)
    if not ok then
        local fixed = M.snippet_fix(snippet)
        ok = pcall(vim.snippet.expand, fixed)

        local msg = ok and "Failed to parse snippet,\nbut was able to fix it automatically."
            or ("Failed to parse snippet.\n" .. err)

        vim.notify(
            ([[%s
```%s
%s
```]]):format(msg, vim.bo.filetype, snippet),
            ok and vim.log.levels.WARN or vim.log.levels.ERROR,
            { title = "vim.snippet" }
        )
    end

    -- Restore top-level session when needed
    if session then
        vim.snippet._session = session
    end
end

M.setup = function(opts)
    local global = opts.global or {}

    for _, source in ipairs(global.sources) do
        source.group_index = source.group_index or 1
    end

    local parse = require("cmp.utils.snippet").parse
    ---@diagnostic disable-next-line: duplicate-set-field
    require("cmp.utils.snippet").parse = function(input)
        local ok, ret = pcall(parse, input)
        if ok then
            return ret
        end
        return M.snippet_preview(input)
    end

    vim.api.nvim_set_hl(0, "CmpGhostText", {
        link = "Comment",
        default = true,
    })

    local cmp = require("cmp")

    cmp.setup.global(opts.global or {})
    cmp.setup.cmdline(":", opts.cmdline or {})
    cmp.setup.cmdline({ "/", "?" }, opts.search or {})

    cmp.event:on("confirm_done", function(event)
        M.auto_brackets(event.entry)
    end)
end

return M
