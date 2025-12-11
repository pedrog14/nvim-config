return {
    "nvim-mini/mini.snippets",
    dependencies = "rafamadriz/friendly-snippets",
    lazy = true,
    main = "utils.plugins.mini.snippets",
    opts = function()
        local gen_loader = require("mini.snippets").gen_loader

        return {
            expand = {
                insert = function(snippet)
                    return require("mini.snippets").default_insert(snippet, { empty_tabstop = "", empty_tabstop_final = "" })
                end,
            },
            mappings = {
                jump_next = "<c-l>",
                jump_prev = "<c-h>",
                stop = "<c-e>",
            },
            snippets = {
                gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
                gen_loader.from_lang(),
            },
        }
    end,
}
