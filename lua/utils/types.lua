---@class cmp.CustomFormatting:cmp.FormattingConfig
---@field fields? cmp.ItemField[]
---@field expandable_indicator? boolean
---@field format? fun(entry: cmp.Entry, vim_item: vim.CompletedItem): vim.CompletedItem

---@class cmp.CustomMatching:cmp.MatchingConfig
---@field disallow_fuzzy_matching? boolean
---@field disallow_fullfuzzy_matching? boolean
---@field disallow_partial_fuzzy_matching? boolean
---@field disallow_partial_matching? boolean
---@field disallow_prefix_unmatching? boolean
---@field disallow_symbol_nonprefix_matching? boolean

---@class cmp.CustomConfig:cmp.ConfigSchema
---@field formatting? cmp.CustomFormatting
---@field matching? cmp.CustomMatching

---@class cmp.Opts
---@field global? cmp.CustomConfig
---@field cmdline? cmp.CustomConfig
---@field search? cmp.CustomConfig

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
