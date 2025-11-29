return {
    "saghen/blink.indent",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    --- @module 'blink.indent'
    --- @type blink.indent.Config
    opts = {
        blocked = { filetypes = { include_defaults = true, "text" } },
        static = { char = "▏" },
        scope = { char = "▏", highlights = { "BlinkIndentScope" } },
    },
}
