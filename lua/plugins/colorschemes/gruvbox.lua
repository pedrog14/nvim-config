return {
  -- "pedrog14/gruvbox.nvim",
  dir = "~/Git/gruvbox.nvim/",
  lazy = false,
  priority = 1000,
  ---@module "gruvbox"
  ---@type GruvboxConfig
  opts = {
    cache = false,
    group_override = function(hl, colors)
      hl.CursorLineNr = { fg = colors.yellow, bg = colors.none, bold = true }
      hl.SignColumn = { fg = colors.bg4, bg = colors.bg0 }
    end,
  },
}
