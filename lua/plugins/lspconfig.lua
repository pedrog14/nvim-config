return {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    lazy = false,
    main = "utils.plugins.lspconfig",
    opts = function()
        local severity = vim.diagnostic.severity
        local diagnostic_icons = require("utils.icons").diagnostics
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
            settings = {
                ["pylsp"] = {
                    pylsp = {
                        plugins = {
                            jedi = {
                                environment = "/usr/bin/python",
                            },
                        },
                    },
                },
            },
            capabilities = require("utils.plugins.lspconfig").default_capabilities(),
            ---@param client vim.lsp.Client
            ---@param bufnr integer
            on_attach = function(client, bufnr)
                local lsp = vim.lsp
                local builtin = require("telescope.builtin")
                local keymap_set = vim.keymap.set

                if client.supports_method("textDocument/inlayHint", { bufnr = bufnr }) then
                    lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end

                if client.supports_method("textDocument/codeLens", { bufnr = bufnr }) then
                    lsp.codelens.refresh()

                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = bufnr,
                        callback = lsp.codelens.refresh,
                    })

                    keymap_set(
                        { "n", "v" },
                        "<leader>cc",
                        lsp.codelens.run,
                        { desc = "Run the code lens in the current line", buffer = bufnr }
                    )

                    keymap_set("n", "<leader>cC", lsp.codelens.refresh, { desc = "Refresh the lenses", buffer = bufnr })
                end

                keymap_set("n", "K", lsp.buf.hover, {
                    desc = "Displays hover information about the symbol under the cursor in a floating window",
                    buffer = bufnr,
                })

                keymap_set(
                    "n",
                    "gD",
                    lsp.buf.declaration,
                    { desc = "Jumps to the declaration of the symbol under the cursor", buffer = bufnr }
                )

                keymap_set({ "n", "i" }, "<c-s>", lsp.buf.signature_help, {
                    desc = "Displays signature information about the symbol under the cursor in a floating window",
                    buffer = bufnr,
                })

                keymap_set(
                    "n",
                    "gO",
                    lsp.buf.document_symbol,
                    { desc = "Lists all symbols in the current buffer in the quickfix window", buffer = bufnr }
                )

                keymap_set(
                    "n",
                    "grn",
                    lsp.buf.rename,
                    { desc = "Renames all references to the symbol under the cursor", buffer = bufnr }
                )

                keymap_set(
                    { "n", "v" },
                    "gra",
                    lsp.buf.code_action,
                    { desc = "Selects a code action available at the current cursor position", buffer = bufnr }
                )

                keymap_set("n", "grr", builtin.lsp_references, {
                    desc = "Lists all the references to the symbol under the cursor in Telescope",
                    buffer = bufnr,
                })

                keymap_set("n", "gri", builtin.lsp_implementations, {
                    desc = "Lists all the implementations for the symbol under the cursor in Telescope",
                    buffer = bufnr,
                })

                keymap_set("n", "grd", builtin.lsp_definitions, {
                    desc = "Jumps to the definition of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
                    buffer = bufnr,
                })

                keymap_set("n", "grt", builtin.lsp_type_definitions, {
                    desc = "Jumps to the definition of the type of the symbol under the cursor, if there's only one, otherwise show all options in Telescope",
                    buffer = bufnr,
                })
            end,
        }
    end,
}
