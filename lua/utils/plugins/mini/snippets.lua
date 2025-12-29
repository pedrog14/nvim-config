local M = {}

M.setup = function(opts)
  -- Stop all sessions on Normal mode exit
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniSnippetsSessionStart",
    callback = function()
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:n",
        once = true,
        callback = function()
          while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
          end
        end,
      })
    end,
  })

  -- Stop session immediately after jumping to final tabstop
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniSnippetsSessionJump",
    callback = function(args)
      if args.data.tabstop_to == "0" then
        MiniSnippets.session.stop()
      end
    end,
  })

  require("mini.snippets").setup(opts)
end

return M
