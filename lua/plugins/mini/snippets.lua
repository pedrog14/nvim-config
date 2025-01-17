return {
    "echasnovski/mini.snippets",
    dependencies = "rafamadriz/friendly-snippets",
    lazy = true,
    opts = function()
        local gen_loader = require("mini.snippets").gen_loader
        return {
            expand = {
                insert = function(snippet)
                    return MiniSnippets.default_insert(
                        snippet,
                        { empty_tabstop = "", empty_tabstop_final = "" }
                    )
                end,
            },
            mappings = {
                -- Interact with default `expand.insert` session.
                -- Created for the duration of active session(s)
                jump_next = "<c-l>",
                jump_prev = "<c-h>",
                stop = "<c-e>",
            },
            snippets = {
                -- Load custom file with global snippets first (adjust for Windows)
                gen_loader.from_file(
                    vim.fn.stdpath("config") .. "/snippets/global.json"
                ),

                -- Load snippets based on current language by reading files from
                -- "snippets/" subdirectories from 'runtimepath' directories.
                gen_loader.from_lang(),
            },
        }
    end,
}
