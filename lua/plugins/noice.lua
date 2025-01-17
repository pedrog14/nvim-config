return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function()
        return {
            cmdline = {
                format = {
                    cmdline = { icon = "󰁔" },
                    search_up = { icon = "󰍉 󱟀" },
                    search_down = { icon = "󰍉 󱞤" },
                    input = { icon = "󰁔" },
                },
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
                progress = { enabled = false },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        }
    end,
}
