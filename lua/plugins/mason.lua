return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    keys = {
      {
        "<leader>m",
        function()
          require("mason.ui").open()
        end,
        desc = "Open Mason",
      },
    },
    main = "utils.plugins.mason",
    ---@module "utils.plugins.mason"
    ---@type utils.mason.opts
    opts = {
      ui = {
        backdrop = 100,
        icons = {
          package_installed = "󰱒",
          package_pending = "󰄱",
          package_uninstalled = "󱋭",
        },
      },
      ensure_installed = {
        -- Formatters
        "autopep8",
        "clang-format",
        "fourmolu",
        "prettier",
        "shfmt",
        "stylua",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = "mason-org/mason.nvim",
    cmd = { "LspInstall", "LspUninstall" },
  },
}
