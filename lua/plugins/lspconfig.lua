return {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    lazy = false,
    main = "utils.plugins.lspconfig",
    ---@param opts Lspconfig.Opts
    opts = function(_, opts)
        local icons = require("utils").icons.diagnostics
        local severity = vim.diagnostic.severity
        local capabilities = require("utils.plugins.lspconfig").default_capabilities
        local settings = {
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

        opts.diagnostic_config = {
            signs = {
                text = {
                    [severity.E] = icons.error,
                    [severity.W] = icons.warn,
                    [severity.I] = icons.info,
                    [severity.N] = icons.hint,
                },
            },
            virtual_text = {
                prefix = "●",
            },
            severity_sort = true,
        }
        opts.on_attach = function(event)
            local keymap_set = vim.keymap.set

            local buf_opts = { buffer = event.buf, silent = true }
            local lsp_buf = vim.lsp.buf
            local builtin = require("telescope.builtin")

            buf_opts.desc = "Displays hover information about the symbol under the cursor in a floating window"
            keymap_set("n", "K", lsp_buf.hover, buf_opts)

            buf_opts.desc =
                "Go to the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope"
            keymap_set("n", "gd", builtin.lsp_definitions, buf_opts)

            buf_opts.desc = "Go to the declaration of the symbol under the cursor"
            keymap_set("n", "gD", lsp_buf.declaration, buf_opts)

            buf_opts.desc =
                "Go to the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope"
            keymap_set("n", "gI", builtin.lsp_implementations, buf_opts)

            buf_opts.desc = "Lists LSP references for word under the cursor, jumps to reference on <cr>"
            keymap_set("n", "gr", builtin.lsp_references, buf_opts)

            buf_opts.desc =
                "Go to the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope"
            keymap_set("n", "gy", builtin.lsp_type_definitions, buf_opts)

            buf_opts.desc = "Displays signature information about the symbol under the cursor in a floating window"
            keymap_set("n", "gK", lsp_buf.signature_help, buf_opts)

            buf_opts.desc = "Displays signature information about the symbol under the cursor in a floating window"
            keymap_set("i", "<c-k>", lsp_buf.signature_help, buf_opts)

            buf_opts.desc = "Renames all references to the symbol under the cursor"
            keymap_set("n", "<leader>cr", lsp_buf.rename, buf_opts)

            buf_opts.desc = "Selects a code action available at the current cursor position"
            keymap_set({ "n", "v" }, "<leader>ca", lsp_buf.code_action, buf_opts)

            buf_opts.desc = "Run the code lens in the current line"
            keymap_set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, buf_opts)

            buf_opts.desc = "Refresh the lenses"
            keymap_set("n", "<leader>cC", vim.lsp.codelens.refresh, buf_opts)
        end
        opts.handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                    settings = settings[server_name],
                })
            end,
        }
    end,
}
