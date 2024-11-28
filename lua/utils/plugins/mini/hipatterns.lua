local hipatterns = require("mini.hipatterns")
local bit = require("bit")
local tohex, bor, lshift = bit.tohex, bit.bor, bit.lshift

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
                .. tohex(bor(lshift(r, 16), lshift(g, 8), b), 6)

            return hipatterns.compute_hex_color_group(hex_color, "bg")
        end,
        extmark_opts = { priority = priority },
    }
end

return M
