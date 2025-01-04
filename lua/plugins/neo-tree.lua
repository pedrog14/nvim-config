return {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
        {
            "<leader>n",
            function()
                require("neo-tree.command").execute({ toggle = true })
            end,
            desc = "Toggle Neo-Tree",
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup(
                "NeotreeStartDirectory",
                { clear = true }
            ),
            desc = "Start Neo-tree with directory",
            once = true,
            callback = function()
                if package.loaded["neo-tree"] then
                    return
                else
                    ---@diagnostic disable-next-line: param-type-mismatch
                    local stats = vim.uv.fs_stat(vim.fn.argv(0))
                    if stats and stats.type == "directory" then
                        require("neo-tree")
                    end
                end
            end,
        })
    end,
    opts = function()
        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*lazygit",
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end,
        })

        local on_move = function(data)
            require("snacks").rename.on_rename_file(
                data.source,
                data.destination
            )
        end
        local events = require("neo-tree.events")

        return {
            event_handlers = {
                { event = events.FILE_MOVED, handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            },
            popup_border_style = "rounded",
            use_popups_for_input = false,
            default_component_configs = {
                indent = {
                    with_expanders = true,
                },
            },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
        }
    end,
}
