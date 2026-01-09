return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  ---@module "todo-comments"
  ---@type TodoOptions
  opts = {
    signs = false,
    keywords = {
      FIX = { icon = " " },
      WARN = { icon = " " },
      TODO = { icon = " " },
      NOTE = { icon = " " },
      HACK = { icon = " " },
      PERF = { icon = " " },
      TEST = { icon = " " },
    },
  },
}
