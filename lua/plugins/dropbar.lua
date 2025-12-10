return {
    "Bekaboo/dropbar.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
        icons = {
            kinds = {
                dir_icon = function(path)
                    local icon, hl = require("mini.icons").get("directory", path)
                    return icon .. " ", hl
                end,
                file_icon = function(path)
                    local icon, hl = require("mini.icons").get("file", path)
                    return icon .. " ", hl
                end,
            },
            ui = { bar = { separator = " 󰅂 " }, menu = { indicator = "󰅂 " } },
        },
    }
}
