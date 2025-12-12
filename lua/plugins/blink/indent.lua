return {
    "saghen/blink.indent",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    ---@module "blink.indent"
    ---@type blink.indent.Config
    opts = {
        static = { char = "▏" },
        scope = { char = "▏", highlights = { "BlinkIndentScope" } },
        blocked = {
            filetypes = { "text", include_defaults = true },
            buftypes = { include_defaults = true },
        },
    },
}
