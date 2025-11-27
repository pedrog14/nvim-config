return {
    "nvim-mini/mini.snippets",
    dependencies = "rafamadriz/friendly-snippets",
    lazy = true,
    opts = function()
        -- Stop all sessions on Normal mode exit
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniSnippetsSessionStart",
            callback = function()
                vim.api.nvim_create_autocmd("ModeChanged", {
                    pattern = "*:n",
                    once = true,
                    callback = function()
                        while MiniSnippets.session.get() do
                            MiniSnippets.session.stop()
                        end
                    end,
                })
            end,
        })

        -- Stop session immediately after jumping to final tabstop
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniSnippetsSessionJump",
            callback = function(args)
                if args.data.tabstop_to == "0" then
                    MiniSnippets.session.stop()
                end
            end,
        })

        local gen_loader = require("mini.snippets").gen_loader
        return {
            expand = {
                insert = function(snippet)
                    return MiniSnippets.default_insert(snippet, { empty_tabstop = "", empty_tabstop_final = "" })
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
