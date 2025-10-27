return {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    event = { "BufNewFile", "BufReadPre" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            cs = { "clang-format" },
            glsl = { "clang-format" },

            css = { "prettier" },
            html = { "prettier" },
            markdown = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },

            sh = { "shfmt" },
            bash = { "shfmt" },
            zsh = { "shfmt" },

            haskell = { "fourmolu" },
            lua = { "stylua" },
            python = { "autopep8" },
            rust = { "rustfmt" },
        },
        default_format_opts = { lsp_format = "fallback" },
        format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
    },
}
