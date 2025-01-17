local M = {}

M.setup = function(opts)
    local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
    end
    local events = require("neo-tree.events")

    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
    })

    require("neo-tree").setup(opts)

    vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
            if package.loaded["neo-tree.sources.git_status"] then
                require("neo-tree.sources.git_status").refresh()
            end
        end,
    })
end

return M
