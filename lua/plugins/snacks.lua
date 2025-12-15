return {
  "folke/snacks.nvim",
  dependencies = "nvim-mini/mini.icons",
  lazy = false,
  priority = 1000,
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "Toggle Explorer (Snacks.picker)",
    },
    {
      "<leader>sf",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files (Snacks.picker)",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live Grep (Snacks.picker)",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers (Snacks.picker)",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages (Snacks.picker)",
    },
    {
      "<leader>sr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files (Snacks.picker)",
    },
    {
      "<leader>se",
      function()
        Snacks.picker.explorer()
      end,
      desc = "Explorer (Snacks.picker)",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.explorer({
          cwd = vim.fn.stdpath("config"),
          title = "Config Files",
        })
      end,
      desc = "Config Files (Snacks.picker)",
    },

    {
      "gR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },

    {
      "<c-w>x",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },

    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Previous Reference",
      mode = { "n", "t" },
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },

    {
      "<c-/>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Toggle Terminal",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end
      end,
    })
  end,
  main = "utils.plugins.snacks",
  opts = function()
    local signs = require("utils.icons").diagnostic.signs

    ---@module "utils.plugins.snacks"
    ---@type utils.snacks.opts
    return {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },

      -- Dashboard
      dashboard = {
        preset = {
          keys = {
            {
              icon = "󰈔",
              desc = "New File",
              key = "n",
              action = ":ene | startinsert",
            },
            {
              icon = "󱧶",
              desc = "Explorer",
              key = "e",
              action = function()
                Snacks.explorer()
              end,
            },
            {
              icon = "󱁿",
              desc = "Config Explorer",
              key = "c",
              action = function()
                Snacks.explorer({
                  cwd = vim.fn.stdpath("config"),
                  title = "Config Explorer",
                })
              end,
            },
            {
              icon = "󰈞",
              desc = "Find Files",
              key = "f",
              action = function()
                Snacks.picker.files()
              end,
            },
            {
              icon = "󱋡",
              desc = "Recent Files",
              key = "r",
              action = function()
                Snacks.picker.recent()
              end,
            },
            {
              icon = "󰒲",
              desc = "Lazy",
              key = "l",
              action = function()
                require("lazy").show()
              end,
            },
            {
              icon = "󰏓",
              desc = "Mason",
              key = "m",
              action = function()
                require("mason.ui").open()
              end,
            },
            {
              icon = "󰈆",
              desc = "Exit Neovim",
              key = "q",
              action = ":quitall",
            },
          },
        },
        formats = { key = { "[%s]" } },
        sections = {
          {
            header = table.concat({
              "████████████████████████████████████████████████████",
              "█████ ██████████████████████████████████████████",
              "████   ███  ████████████ █████ █ ██ ████",
              "███     █     █      ██ ███      ███",
              "██  █       ██ ██               ██",
              "██  ███   █   ██ ██ █      █  █  ██",
              "███████ ██    █    ███ █ █  ███████ ██",
              "████████████████████████████████████████████████████",
            }, "\n"),
            padding = 2,
          },
          { section = "keys", gap = 1, padding = 2 },
          { section = "startup" },
        },
      },

      -- Explorer
      explorer = { replace_netrw = true },

      -- Input
      input = { icon = "" },

      -- Notifier
      notifier = {
        icons = { error = signs[1], warn = signs[2], info = signs[3] },
      },

      -- Picker
      picker = {
        icons = {
                    -- stylua: ignore
                    diagnostics = {
                        Error = signs[1],
                        Warn  = signs[2],
                        Info  = signs[3],
                        Hint  = signs[4],
                    },
        },
        prompt = " ",
      },

      -- Styles
      styles = {
        notification = { wo = { wrap = true, winblend = 0 } },
        lazygit = { border = "rounded" },
        input = {
          keys = {
            i_esc = { "<esc>", "stopinsert", mode = "i" },
            i_cr = { "<cr>", "confirm", mode = "i" },
          },
        },
      },

      -- Terminal
      terminal = {
        win = { wo = { winhighlight = "" } },
      },

      -- Win
      win = { backdrop = false },
    }
  end,
}
