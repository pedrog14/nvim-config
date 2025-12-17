return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  ---@module "treesitter-context"
  ---@type TSContext.UserConfig
  opts = { max_lines = 3, separator = "─", multiwindow = true },
}
