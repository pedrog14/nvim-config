return {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    lazy = false,
    main = "utils.plugins.lspconfig",
    opts = function(_, opts)
        local diagnostics_icons = require("utils.icons").diagnostics

        ---@type vim.diagnostic.Opts
        opts.diagnostics = {
            signs = {
                text = {
                    [vim.diagnostic.severity.E] = diagnostics_icons.error,
                    [vim.diagnostic.severity.W] = diagnostics_icons.warn,
                    [vim.diagnostic.severity.I] = diagnostics_icons.info,
                    [vim.diagnostic.severity.N] = diagnostics_icons.hint,
                },
            },
            virtual_text = {
                prefix = "●",
            },
            severity_sort = true,
        }

        opts.settings = {
            ["pylsp"] = {
                pylsp = {
                    plugins = {
                        jedi = {
                            environment = "/usr/bin/python",
                        },
                    },
                },
            },
        }

        opts.capabilities = require("utils.plugins.lspconfig").default_capabilities

        opts.on_attach = function(client, bufnr)
            local keymap_set = vim.keymap.set

            local lsp_opts = { buffer = bufnr, silent = true }
            local lsp_buf = vim.lsp.buf
            local builtin = require("telescope.builtin")

            lsp_opts.desc = "Displays hover information about the symbol under the cursor in a floating window"
            keymap_set("n", "K", lsp_buf.hover, lsp_opts)

            lsp_opts.desc =
                "Go to the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope"
            keymap_set("n", "gd", builtin.lsp_definitions, lsp_opts)

            lsp_opts.desc = "Go to the declaration of the symbol under the cursor"
            keymap_set("n", "gD", lsp_buf.declaration, lsp_opts)

            lsp_opts.desc =
                "Go to the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope"
            keymap_set("n", "gy", builtin.lsp_type_definitions, lsp_opts)

            lsp_opts.desc = "Displays signature information about the symbol under the cursor in a floating window"
            keymap_set("n", "gK", lsp_buf.signature_help, lsp_opts)

            lsp_opts.desc = "Displays signature information about the symbol under the cursor in a floating window"
            keymap_set("i", "<c-s>", lsp_buf.signature_help, lsp_opts)

            lsp_opts.desc = "Run the code lens in the current line"
            keymap_set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, lsp_opts)

            lsp_opts.desc = "Refresh the lenses"
            keymap_set("n", "<leader>cC", vim.lsp.codelens.refresh, lsp_opts)

            lsp_opts.desc = "Renames all references to the symbol under the cursor"
            keymap_set("n", "grn", lsp_buf.rename, lsp_opts)

            lsp_opts.desc = "Selects a code action available at the current cursor position"
            keymap_set({ "n", "v" }, "gra", lsp_buf.code_action, lsp_opts)

            lsp_opts.desc = "Lists LSP references for word under the cursor, jumps to reference on <cr>"
            keymap_set("n", "grr", builtin.lsp_references, lsp_opts)

            lsp_opts.desc =
                "Go to the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope"
            keymap_set("n", "gri", builtin.lsp_implementations, lsp_opts)
        end
    end,
}
