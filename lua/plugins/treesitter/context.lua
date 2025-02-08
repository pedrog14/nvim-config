return {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufNewFile", "BufReadPre" },
    opts = {
        max_lines = 3,
        -- separator = "─",
    },
}
