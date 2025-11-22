return {
    "pedrog14/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    ---@module "gruvbox"
    ---@type GruvboxConfig
    opts = {
        group_override = function(hl, colors)
            hl.CursorLineNr = { fg = colors.yellow, bg = colors.none, bold = true }
            hl.SignColumn = { bg = colors.bg0 }
        end,
    },
}
