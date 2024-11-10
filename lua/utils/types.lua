---@class DashboardShortcut
---@field icon string
---@field icon_hl string
---@field desc string
---@field desc_hl string
---@field key string
---@field key_hl string
---@field key_format string
---@field action string

---@class DashboardCenter
---@field [integer] { [1]: string|false, [2]: string|false, [3]: string, [4]: string }

---@class Lspconfig.Opts
---@field diagnostic_config? vim.diagnostic.Opts
---@field on_attach? fun(event)
---@field handlers? table<string, fun(server_name: string)>
