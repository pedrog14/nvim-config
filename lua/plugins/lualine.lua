return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local snacks_picker = {
            sections = {
                lualine_a = {
                    function()
                        return "Snacks.picker"
                    end,
                },
            },
            filetypes = {
                "snacks_picker_input",
                "snacks_picker_list",
                "snacks_picker_preview",
            },
        }

        local signs = require("utils.icons").diagnostic.signs

        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "snacks_dashboard" },
                },
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    { "diagnostics", symbols = signs },
                },
                lualine_x = {
                    "encoding",
                    "fileformat",
                    "filetype",
                    {
                        "lsp_status",
                        icon = "󰒓",
                        symbols = {
                            -- Standard unicode symbols to cycle through for LSP progress:
                            spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                            -- Standard unicode symbol for when LSP is done:
                            done = "󰗠",
                            -- Delimiter inserted between LSP names:
                            separator = " ",
                        },
                        -- List of LSP names to ignore (e.g., `null-ls`):
                        ignore_lsp = {},
                    },
                },
            },
            extensions = {
                "lazy",
                "mason",
                "neo-tree",
                "quickfix",
                snacks_picker,
            },
        }
    end,
}
