local M = {}

M.adjust_header = function(header, db_height)
    local win_height = vim.o.lines

    local line_break = math.floor(win_height / 2) - math.ceil(db_height / 2)
    local header_space = string.rep("\n", line_break)

    return header_space .. table.concat(header) .. "\n"
end

---@param icon string|false
---@param desc string|false
---@param key string
---@param action string
---@param width integer
---@return DashboardShortcut
M.gen_shortcut = function(icon, desc, key, action, width)
    local hl = {
        icon = "DashboardCenter",
        desc = "DashboardCenter",
        key = "DashboardShortCut",
    }
    local key_format = "[%s]"
    return {
        icon = icon or "",
        icon_hl = hl.icon,
        desc = (desc and #desc > 0) and desc .. string.rep(" ", width - (#desc + #key + 2)) or "",
        desc_hl = hl.desc,
        key = key,
        key_hl = hl.key,
        key_format = key_format,
        action = action,
    }
end

---@param shortcuts table[]
---@param width integer
---@return DashboardShortcut[]
M.gen_center = function(shortcuts, width)
    local center = {}
    for _, shortcut in ipairs(shortcuts) do
        local icon, desc, key, action = unpack(shortcut)
        center[#center + 1] = M.gen_shortcut(icon, desc, key, action, width)
    end
    return center
end

M.setup = function(opts)
    local config = opts.config
    local db_height = #config.header + (#config.center * 2) + #config.footer + 3

    local header = M.adjust_header(config.header, db_height)
    local center = M.gen_center(config.center, (vim.api.nvim_strwidth(config.header[1]) - 1) - 4)
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
