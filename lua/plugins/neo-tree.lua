return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        requires = "s1n7ax/nvim-window-picker",
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
                group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
                desc = "Start Neo-tree with directory",
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then
                        return
                    else
                        local stats = vim.uv.fs_stat(vim.fn.argv(0))
                        if stats and stats.type == "directory" then
                            require("neo-tree")
                        end
                    end
                end,
            })
        end,
        opts = {
            popup_border_style = "rounded",
            default_component_configs = {
                indent = {
                    with_expanders = true,
                },
            },
            window = {
                mappings = {
                    ["s"] = "vsplit_with_window_picker",
                    ["S"] = "split_with_window_picker",
                },
            },
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
        },
    },

    {
        "s1n7ax/nvim-window-picker",
        lazy = true,
        name = "window-picker",
        opts = {
            filter_rules = {
                include_current_win = false,
                autoselect_one = true,
                bo = {
                    filetype = {
                        "neo-tree",
                        "neo-tree-popup",
                        "notify",
                    },
                    buftype = { "terminal", "quickfix" },
                },
            },
        },
    },
}
