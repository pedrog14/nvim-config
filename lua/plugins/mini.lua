return {
    {
        "echasnovski/mini.icons",
        lazy = true,
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        opts = {},
    },

    {
        "echasnovski/mini.surround",
        event = { "BufNewFile", "BufReadPre" },
        opts = {
            mappings = {
                add = "gs", -- Add surrounding in Normal and Visual modes
                delete = "ds", -- Delete surrounding
                replace = "cs", -- Replace surrounding

                find = "", -- Find surrounding (to the right)
                find_left = "", -- Find surrounding (to the left)
                highlight = "", -- Highlight surrounding
                update_n_lines = "", -- Update `n_lines`
            },
        },
    },
}
