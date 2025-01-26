return {
    "echasnovski/mini.hipatterns",
    event = { "BufNewFile", "BufReadPre" },
    opts = function()
        local hipatterns = require("mini.hipatterns")
        return {
            highlighters = {
                rgb_color = {
                    pattern = "rgb%(%d+, ?%d+, ?%d+%)",
                    ---@param match string
                    group = function(_, match)
                        local r, g, b =
                            match:match("rgb%((%d+), ?(%d+), ?(%d+)%)")

                        local hex_color =
                            string.format("#%02x%02x%02x", r, g, b)

                        return MiniHipatterns.compute_hex_color_group(
                            hex_color,
                            "bg"
                        )
                    end,
                },
                rgba_color = {
                    pattern = "rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)",
                    ---@param match string
                    group = function(_, match)
                        local r, g, b, a = match:match(
                            "rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)"
                        )
                        a = tonumber(a)

                        if a == nil or a < 0 or a > 1 then
                            return false
                        end

                        local hex_color =
                            string.format("#%02x%02x%02x", r * a, g * a, b * a)

                        return MiniHipatterns.compute_hex_color_group(
                            hex_color,
                            "bg"
                        )
                    end,
                },
                hex_color = hipatterns.gen_highlighter.hex_color({
                    priority = 2000,
                }),
                hex_alpha = {
                    pattern = "#%x%x%x%x%x%x%x%x%f[%X]",
                    group = function(_, match)
                        local r, g, b, a =
                            tonumber(match:sub(2, 3), 16),
                            tonumber(match:sub(4, 5), 16),
                            tonumber(match:sub(6, 7), 16),
                            tonumber(match:sub(8, 9), 16) / 255

                        local hex_color =
                            string.format("#%02x%02x%02x", r * a, g * a, b * a)

                        return MiniHipatterns.compute_hex_color_group(
                            hex_color,
                            "bg"
                        )
                    end,
                    extmark_opts = { priority = 2000 },
                },
                shorthand = {
                    pattern = "#%x%x%x%f[%X]",
                    group = function(_, match)
                        local r, g, b =
                            match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
                        local hex_color = "#" .. r .. r .. g .. g .. b .. b

                        return MiniHipatterns.compute_hex_color_group(
                            hex_color,
                            "bg"
                        )
                    end,
                    extmark_opts = { priority = 2000 },
                },
            },
        }
    end,
}
