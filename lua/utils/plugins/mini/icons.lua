local M = {}

M.setup = function(opts)
  require("mini.icons").setup(opts)

  MiniIcons.mock_nvim_web_devicons()
end

return M
