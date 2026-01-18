return {
  "saghen/blink.indent",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  --- @module "blink.indent"
  --- @type blink.indent.Config
  opts = {
    blocked = {
      filetypes = { include_defaults = true, "text" },
      buftypes = { include_defaults = true },
    },
    static = { char = "▏" },
    scope = { enabled = false },
  },
}
