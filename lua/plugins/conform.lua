return {
    "stevearc/conform.nvim",
    event = { "BufNewFile", "BufReadPre" },
    opts = function(_, opts)
        opts.formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            cs = { "clang-format" },
            css = { "prettier" },
            cuda = { "clang-format" },
            go = { "gofumpt" },
            graphql = { "prettier" },
            handlebars = { "prettier" },
            haskell = { "fourmolu" },
            html = { "prettier" },
            java = { "clang-format" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            less = { "prettier" },
            lua = { "stylua" },
            luau = { "stylua" },
            ["markdown.mdx"] = { "prettier" },
            python = { "black" },
            scss = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            vue = { "prettier" },
            sh = { "shfmt" },
            yaml = { "prettier" },
        }
        opts.default_format_opts = { lsp_format = "fallback" }
        opts.format_on_save = { lsp_format = "fallback", timeout_ms = 500 }
    end,
}
