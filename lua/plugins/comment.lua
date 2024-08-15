return {
    {
        "numToStr/Comment.nvim",
        event = {
            "BufNewFile",
            "BufReadPre",
        },
        opts = function(_, opts)
            local pre_hook = require(
                "ts_context_commentstring.integrations.comment_nvim"
            ).create_pre_hook()
            opts.pre_hook = pre_hook
        end,
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enable_autocmd = false,
        },
    },
}
