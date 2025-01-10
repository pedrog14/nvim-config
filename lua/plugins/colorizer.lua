return {
    "catgoose/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
        lazy_load = true,
        filetypes = { "*", "!lazy", "!mason", "!TelescopePrompt" },
        user_default_options = { css = true },
    },
}
