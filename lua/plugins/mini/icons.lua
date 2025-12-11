return {
    "nvim-mini/mini.icons",
    lazy = true,
    init = function()
        package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end,
    opts = {
        lsp = {
            constructor   = { glyph = '' },
            ['function']  = { glyph = '' },
            key           = { glyph = '' },
            null          = { glyph = '' },
            number        = { glyph = '' },
            object        = { glyph = '' },
            package       = { glyph = '' },
            reference     = { glyph = '' },
            value         = { glyph = '' },
        }
    },
}
