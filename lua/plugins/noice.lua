return {
    "folke/noice.nvim",
    event = "VeryLazy",
    ---@module "noice"
    ---@type NoiceConfig
    opts = {
        cmdline = {
            format = {
                cmdline = { icon = "󰁔" },
                search_up = { icon = "󰍉 󰁝" },
                search_down = { icon = "󰍉 󰁅" },
                input = { icon = "󰁔" },
            },
        },
        lsp = {
            progress = {
                format = {
                    {
                        "{progress} ",
                        key = "progress.percentage",
                        contents = {
                            { "{data.progress.message} " },
                        },
                    },
                    { "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
                    { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
                    { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
                },
                format_done = {
                    { "󰄬 ", hl_group = "NoiceLspProgressSpinner" },
                    { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
                    { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
                },
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
        },
        views = {
            confirm = {
                win_options = {
                    winhighlight = { FloatTitle = "NoiceCmdlinePopupTitle" },
                },
            },
        },
    },
}
