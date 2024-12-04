return {
    "neovim/nvim-lspconfig",
    dependencies = "williamboman/mason-lspconfig.nvim",
    event = { "BufNewFile", "BufReadPre" },
    main = "utils.plugins.lspconfig",
    opts = function()
        local severity = vim.diagnostic.severity
        local diagnostic_icons = require("utils").icons.diagnostics
        ---@type lspconfig.Opts
        return {
            diagnostics = {
                signs = {
                    text = {
                        [severity.E] = diagnostic_icons.error,
                        [severity.W] = diagnostic_icons.warn,
                        [severity.I] = diagnostic_icons.info,
                        [severity.N] = diagnostic_icons.hint,
                    },
                },
                virtual_text = {
                    prefix = "●",
                },
                severity_sort = true,
            },
            settings = {},
            capabilities = require("utils").plugins.lspconfig.client_capabilities(),
            on_attach = function(client, bufnr)
                local lsp = vim.lsp
                local builtin = require("telescope.builtin")
                local keymap_set = vim.keymap.set

                if client:supports_method("textDocument/inlayHint", bufnr) then
                    lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end

                if client:supports_method("textDocument/codeLens", bufnr) then
                    lsp.codelens.refresh({ bufnr = bufnr })

                    vim.api.nvim_create_autocmd(
                        { "BufEnter", "CursorHold", "InsertLeave" },
                        {
                            buffer = bufnr,
                            callback = lsp.codelens.refresh,
                        }
                    )

                    keymap_set({ "n", "v" }, "<leader>cc", function()
                        lsp.codelens.run()
                    end, {
                        desc = "Run the code lens in the current line",
                        buffer = bufnr,
                    })

                    keymap_set("n", "<leader>cC", function()
                        lsp.codelens.refresh({ bufnr = bufnr })
                    end, {
                        desc = "Refresh the lenses",
                        buffer = bufnr,
                    })
                end

                if client:supports_method("textDocument/completion", bufnr) then
                    local completion = require("utils").completion

                    completion.enable(true, client.id, bufnr, {
                        autotrigger = true,
                        convert = completion.client_convert(client, bufnr),
                    })

                    -- Better completion
                    vim.keymap.set("i", "<c-n>", function()
                        if completion.is_visible() then
                            completion.exec_keys("<c-n>")
                        else
                            completion.trigger()
                        end
                    end, {
                        desc = "Open or Select Next Completion",
                        buffer = bufnr,
                    })
                end

                keymap_set("n", "K", function()
                    lsp.buf.hover()
                end, {
                    desc = "Displays hover information about the symbol under the cursor in a floating window",
                    buffer = bufnr,
                })

                keymap_set("n", "gD", function()
                    lsp.buf.declaration()
                end, {
                    desc = "Jumps to the declaration of the symbol under the cursor",
                    buffer = bufnr,
                })

                keymap_set({ "n", "i" }, "<c-s>", function()
                    lsp.buf.signature_help()
                end, {
                    desc = "Displays signature information about the symbol under the cursor in a floating window",
                    buffer = bufnr,
                })

                keymap_set("n", "gO", function()
                    lsp.buf.document_symbol()
                end, {
                    desc = "Lists all symbols in the current buffer in the quickfix window",
                    buffer = bufnr,
                })

                keymap_set("n", "grn", function()
                    lsp.buf.rename()
                end, {
                    desc = "Renames all references to the symbol under the cursor",
                    buffer = bufnr,
                })

                keymap_set({ "n", "x" }, "gra", function()
                    lsp.buf.code_action()
                end, {
                    desc = "Selects a code action available at the current cursor position",
                    buffer = bufnr,
                })

                keymap_set("n", "grr", function()
                    builtin.lsp_references()
                end, {
                    desc = "Lists all the references to the symbol under the cursor in Telescope",
                    buffer = bufnr,
                })

                keymap_set("n", "gri", function()
                    builtin.lsp_implementations()
                end, {
                    desc = "Jumps to the implementation of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
                    buffer = bufnr,
                })

                keymap_set("n", "grd", function()
                    builtin.lsp_definitions()
                end, {
                    desc = "Jumps to the definition of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
                    buffer = bufnr,
                })

                keymap_set("n", "grt", function()
                    builtin.lsp_type_definitions()
                end, {
                    desc = "Jumps to the definition of the type of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
                    buffer = bufnr,
                })
            end,
        }
    end,
}
