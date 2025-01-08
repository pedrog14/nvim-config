return {
    "catgoose/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
        filetypes = { "*", "!lazy", "!mason", "!TelescopePrompt" },
        user_default_options = { css = true },
    },
}
