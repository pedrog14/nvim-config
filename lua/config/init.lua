---------------------
-- 󰒓 Neovim config --
---------------------

local config = {}

config.setup = function()
    require("config.options")
    require("config.lazy")
    require("config.keymaps")
    vim.cmd.colorscheme("gruvbox")
end

return config
