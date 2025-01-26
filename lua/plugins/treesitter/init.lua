return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufNewFile", "BufReadPre", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
        { "<c-space>", desc = "Increment selection", mode = { "x", "n" } },
        { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    init = function(plugin)
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
    end,
    main = "nvim-treesitter.configs",
    opts = {
        -- Base
        ensure_installed = {
            "c",
            "lua",
            "bash",
            "vim",
            "vimdoc",
            "query",
            "regex",
            "markdown",
            "markdown_inline",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            disable = function(_, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats =
                    pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        indent = { enable = true },

        -- Incremental Selection
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        },
    },
}
