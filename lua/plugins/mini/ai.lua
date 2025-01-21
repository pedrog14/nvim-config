return {
    "echasnovski/mini.ai",
    event = { "BufNewFile", "BufReadPre" },
    opts = function()
        local ai = require("mini.ai")
        return {
            n_lines = 500,
            custom_textobjects = {
                o = ai.gen_spec.treesitter({ -- code block
                    a = {
                        "@block.outer",
                        "@conditional.outer",
                        "@loop.outer",
                    },
                    i = {
                        "@block.inner",
                        "@conditional.inner",
                        "@loop.inner",
                    },
                }),
                f = ai.gen_spec.treesitter({ -- function
                    a = "@function.outer",
                    i = "@function.inner",
                }),
                c = ai.gen_spec.treesitter({ -- class
                    a = "@class.outer",
                    i = "@class.inner",
                }),
                t = {
                    "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", -- tags

                    "^<.->().*()</[^/]->$",
                },
                d = { "%f[%d]%d+" }, -- digits
                e = { -- Word with case
                    {
                        "%u[%l%d]+%f[^%l%d]",
                        "%f[%S][%l%d]+%f[^%l%d]",
                        "%f[%P][%l%d]+%f[^%l%d]",
                        "^[%l%d]+%f[^%l%d]",
                    },
                    "^().*()$",
                },
                u = ai.gen_spec.function_call(), -- u for "Usage"
                U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
            },
        }
    end,
}
