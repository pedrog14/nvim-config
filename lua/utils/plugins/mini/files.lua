local M = {}

M.setup = function(opts)
    require("mini.files").setup(opts)

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
            local win_opts = opts.windows
            local win_id = args.data.win_id

            -- Customize window-local settings
            local config = vim.api.nvim_win_get_config(win_id)

            config.border = win_opts.border or config.border
            config.title_pos = win_opts.title_pos or config.title_pos

            vim.api.nvim_win_set_config(win_id, config)
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowUpdate",
        callback = function(args)
            local win_id = args.data.win_id
            local config = vim.api.nvim_win_get_config(win_id)

            -- Ensure title padding
            if config.title[#config.title][1] ~= " " then
                table.insert(config.title, { " ", "NormalFloat" })
            end
            if config.title[1][1] ~= " " then
                table.insert(config.title, 1, { " ", "NormalFloat" })
            end

            vim.api.nvim_win_set_config(win_id, config)
        end,
    })
end

return M
