return {
    {
        "neovim/nvim-lspconfig",
        dependencies = "williamboman/mason-lspconfig.nvim",
        lazy = false,
        main = "utils.plugins.lspconfig",
        opts = {
            diagnostics = {
                signs = {
                    text = {
                        [vim.diagnostic.severity.E] = require("utils.icons").diagnostics.error,
                        [vim.diagnostic.severity.W] = require("utils.icons").diagnostics.warn,
                        [vim.diagnostic.severity.I] = require("utils.icons").diagnostics.info,
                        [vim.diagnostic.severity.N] = require("utils.icons").diagnostics.hint,
                    },
                },
                virtual_text = {
                    prefix = "●",
                },
                severity_sort = true,
            },
            settings = {
                ["lua_ls"] = {
                    Lua = {
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME },
                        },
                    },
                },
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
                local methods = vim.lsp.protocol.Methods

                local keymap_set = vim.keymap.set

                ---@type vim.keymap.set.Opts
                local lsp_opts = { buffer = bufnr, silent = true }

                if client:supports_method(methods.textDocument_inlayHint, bufnr) then
                    lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end

                if client:supports_method(methods.textDocument_codeLens, bufnr) then
                    lsp.codelens.refresh()

                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = bufnr,
                        callback = lsp.codelens.refresh,
                    })

                    lsp_opts.desc = "Run the code lens in the current line"
                    keymap_set({ "n", "v" }, "<leader>cc", lsp.codelens.run, lsp_opts)

                    lsp_opts.desc = "Refresh the lenses"
                    keymap_set("n", "<leader>cC", lsp.codelens.refresh, lsp_opts)
                end

                if client:supports_method(methods.textDocument_completion, bufnr) then
                    local completion = require("utils.completion")

                    completion.enable(true, client.id, bufnr, {
                        autotrigger = true,
                        convert = completion.format_completion(),
                    })

                    keymap_set({ "i", "s" }, "<c-n>", function()
                        return completion.is_visible() and "<c-n>" or "<c-x><c-o>"
                    end, { expr = true, silent = true, buffer = bufnr })
                end

                lsp_opts.desc = "Displays hover information about the symbol under the cursor in a floating window"
                keymap_set("n", "K", lsp.buf.hover, lsp_opts)

                lsp_opts.desc = "Jumps to the declaration of the symbol under the cursor"
                keymap_set("n", "gD", lsp.buf.declaration, lsp_opts)

                lsp_opts.desc = "Displays signature information about the symbol under the cursor in a floating window"
                keymap_set({ "n", "i" }, "<c-s>", lsp.buf.signature_help, lsp_opts)

                lsp_opts.desc = "Lists all symbols in the current buffer in the quickfix window"
                keymap_set("n", "gO", lsp.buf.document_symbol, lsp_opts)

                lsp_opts.desc = "Renames all references to the symbol under the cursor"
                keymap_set("n", "grn", lsp.buf.rename, lsp_opts)

                lsp_opts.desc = "Selects a code action available at the current cursor position"
                keymap_set({ "n", "v" }, "gra", lsp.buf.code_action, lsp_opts)

                lsp_opts.desc = "Lists all the references to the symbol under the cursor in Telescope"
                keymap_set("n", "grr", builtin.lsp_references, lsp_opts)

                lsp_opts.desc = "Lists all the implementations for the symbol under the cursor in Telescope"
                keymap_set("n", "gri", builtin.lsp_implementations, lsp_opts)

                lsp_opts.desc =
                    "Jumps to the definition of the symbol under the cursor, if there's only one, otherwise show all options in Telescope"
                keymap_set("n", "grd", builtin.lsp_definitions, lsp_opts)

                lsp_opts.desc =
                    "Jumps to the definition of the type of the symbol under the cursor, if there's only one, otherwise show all options in Telescope"
                keymap_set("n", "grt", builtin.lsp_type_definitions, lsp_opts)
            end,
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
    },
}
