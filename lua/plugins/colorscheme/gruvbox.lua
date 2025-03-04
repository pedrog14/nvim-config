return {
    "pedrog14/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = { --[[@type GruvboxConfig]]
        group_override = function(highlights, colors)
            local hl = highlights
            hl.CursorLineNr = { fg = colors.yellow, bg = colors.none, bold = true }
            hl.SignColumn = { bg = colors.bg0 }
        end,
    },
}
