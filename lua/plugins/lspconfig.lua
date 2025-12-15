return {
  "neovim/nvim-lspconfig",
  dependencies = "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
  cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
  main = "utils.plugins.lspconfig",
  ---@module "utils.plugins.lspconfig"
  ---@type utils.lspconfig.opts
  opts = {
    ensure_installed = {
      "bashls",
      "cssls",
      "clangd",
      "hls",
      "html",
      "jdtls",
      "jsonls",
      "lua_ls",
      "pylsp",
      "rust_analyzer",
      "ts_ls",
      "vimls",
    },
    diagnostic = {
      severity_sort = true,
      signs = { text = require("utils.icons").diagnostic.signs },
    },
    servers = {
      ["*"] = {
        capabilities = {
          workspace = {
            fileOperations = { didRename = true, willRename = true },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            hint = {
              paramName = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      },
    },
    semantic_tokens = { enabled = true },
    codelens = { enabled = true },
    inlay_hint = { enabled = true },
    fold = { enabled = true },
  },
}
