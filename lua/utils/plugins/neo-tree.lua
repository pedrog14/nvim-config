local M = {}

M.setup = function(opts)
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
