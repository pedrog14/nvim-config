---@class DashboardShortcut
---@field icon string
---@field icon_hl string
---@field desc string
---@field desc_hl string
---@field key string
---@field key_hl string
---@field key_format string
---@field action string|function

---@class DashboardCenter: { [1]: string, [2]: string, [3]: string, [4]: string|function }

---@class EventArgs
---@field id number
---@field event string
---@field group number|nil
---@field match string
---@field buf number
---@field file string
---@field data any

---@class Lspconfig.Opts: MasonLspconfigSettings
---@field diagnostic_config? vim.diagnostic.Opts
---@field on_attach? fun(event: EventArgs)
