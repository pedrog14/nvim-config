---@class utils.treesitter.textobjects.move: TSTextObjects.Config.Move
---@field enable? boolean
---@field keys? table<string, table<string, string>>

---@class utils.treesitter.textobjects.opts: TSTextObjects.UserConfig
---@field move? utils.treesitter.textobjects.move

local M = {}

---@param opts utils.treesitter.textobjects.opts
M.setup = function(opts)
    local textobjects = require("nvim-treesitter-textobjects")
    local utils = require("utils.treesitter")

    textobjects.setup(opts)

    local attach = function(buf)
        local lang = vim.treesitter.language.get_lang(vim.api.nvim_get_option_value("filetype", { buf = buf }))
        if not (lang and vim.tbl_get(opts, "move", "enable") and utils.get_query(lang, "textobjects")) then
            return
        end
        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, "move", "keys") or {}

        for method, keymaps in pairs(moves) do
            for key, query in pairs(keymaps) do
                local queries = type(query) == "table" and query or { query }
                local parts = {}
                for _, q in ipairs(queries) do
                    local part = q:gsub("@", ""):gsub("%..*", "")
                    part = part:sub(1, 1):upper() .. part:sub(2)
                    table.insert(parts, part)
                end
                local desc = table.concat(parts, " or ")
                desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
                desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
                if
                    not (
                        vim.api.nvim_get_option_value("diff", { win = vim.api.nvim_get_current_win() })
                        and key:find("[cC]")
                    )
                then
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                        require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
                    end, {
                        buffer = buf,
                        desc = desc,
                        silent = true,
                    })
                end
            end
        end
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("textobjects_config", { clear = true }),
        callback = function(args)
            attach(args.buf)
        end,
    })

    vim.tbl_map(attach, vim.api.nvim_list_bufs())
end

return M
