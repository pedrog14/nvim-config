local M = {}

---@param header string[]
---@param db_height integer
---
---@return string
M.adjust_header = function(header, db_height)
    local win_height = vim.o.lines

    local line_break = math.floor(win_height / 2) - math.ceil(db_height / 2)
    local header_space = string.rep("\n", line_break)

    return header_space .. table.concat(header) .. "\n"
end

---@param icon string
---@param desc string
---@param key string
---@param action string|fun()
---@param width integer
---
---@return DashboardShortcut
M.gen_shortcut = function(icon, desc, key, action, width)
    local hl = {
        icon = "DashboardCenter",
        desc = "DashboardCenter",
        key = "DashboardShortCut",
    }
    local key_format = "[%s]"

    local space_rep = width - vim.api.nvim_strwidth(icon .. desc .. key .. key_format)
    desc = desc .. string.rep(" ", space_rep - 4)

    return {
        icon = icon,
        icon_hl = hl.icon,
        desc = desc,
        desc_hl = hl.desc,
        key = key,
        key_hl = hl.key,
        key_format = key_format,
        action = action,
    }
end

---@param shortcuts DashboardCenter[]
---@param width integer
---
---@return DashboardShortcut[]
M.gen_center = function(shortcuts, width)
    local center = {}
    for _, shortcut in ipairs(shortcuts) do
        local icon, desc, key, action = shortcut[1], shortcut[2], shortcut[3], shortcut[4]
        center[#center + 1] = M.gen_shortcut(icon, desc, key, action, width)
    end
    return center
end

M.setup = function(opts)
    local config = opts.config
    local db_height = #config.header + (#config.center * 2) + #config.footer + 3

    local header = M.adjust_header(config.header, db_height)
    local center = M.gen_center(config.center, vim.api.nvim_strwidth(config.header[1]) - 1)
    local footer = config.footer

    require("dashboard").setup(vim.tbl_deep_extend("force", opts, {
        config = {
            header = vim.split(header, "\n"),
            center = center,
            footer = vim.split("\n" .. table.concat(footer), "\n"),
        },
    }))
end

return M
