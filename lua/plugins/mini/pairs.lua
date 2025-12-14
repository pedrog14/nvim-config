return {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    main = "utils.plugins.mini.pairs",
    opts = {
        modes = { insert = true, command = false, terminal = false },
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        skip_ts = { "string" },
        skip_unbalanced = true,
        markdown = true,
    },
}
