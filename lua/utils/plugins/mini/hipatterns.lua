local bit = require("bit")

---@class utils.plugins.mini.hipatterns
local M = {}

M.shorthand = function(opts)
    local priority = opts.priority or 200
    return {
        pattern = "()#%x%x%x()%f[^%x%w]",
        group = function(_, _, data)
            ---@type string
            local match = data.full_match
            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
            local hex_color = "#" .. r .. r .. g .. g .. b .. b

            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
        end,
        extmark_opts = { priority = priority },
    }
end

M.hex_alpha_color = function(opts)
    local priority = opts.priority or 200
    return {
        pattern = "()#%x%x%x%x%x%x%x%x()%f[^%x%w]",
        group = function(_, _, data)
            ---@type string
            local match = data.full_match
            local r, g, b, a =
                tonumber(match:sub(2, 3), 16),
                tonumber(match:sub(4, 5), 16),
                tonumber(match:sub(6, 7), 16),
                tonumber(match:sub(8, 9), 16) / 255

            r = math.floor(r * a)
            g = math.floor(g * a)
            b = math.floor(b * a)

            local hex_color = "#"
                .. bit.tohex(bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b), 6)

            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
        end,
        extmark_opts = { priority = priority },
    }
end

return M
