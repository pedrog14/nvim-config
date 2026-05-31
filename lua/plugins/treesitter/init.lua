return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy",
  main = "utils.plugins.treesitter",
  ---@module "utils.plugins.treesitter"
  ---@type utils.treesitter.Opts
  opts = {
    ensure_installed = {
      "c",
      "lua",
      "bash",
      "zsh",
      "vim",
      "vimdoc",
      "query",
      "regex",
      "markdown",
      "markdown_inline",
      "html",
      "javascript",
      "latex",
      "scss",
      "svelte",
      "tsx",
      "typst",
      "vue",
    },
  },
}
