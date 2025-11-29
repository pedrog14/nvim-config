return {
    "saghen/blink.indent",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    --- @module 'blink.indent'
    --- @type blink.indent.Config
    opts = {
        static = { char = "▏" },
        scope = { enabled = false, char = "▏", highlights = { "BlinkIndentScope" } },
    },
}
