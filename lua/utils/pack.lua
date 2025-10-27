---@class utils.pack.Data
---@field config? fun(opts?: table)
---@field dependency? string[]
---@field lazy? utils.pack.Data.Lazy
---@field module? string
---@field opts? table|fun(): table

---@class utils.pack.Data.Lazy
---@field cmd? string[]
---@field event? string|string[]
---@field ft? string|string[]

local M = {}

M._spec = nil ---@type table<string, vim.pack.SpecResolved>?

---@param dir string?
---@return string[]
local require_list = function(dir)
    dir = dir or ""

    local list = {}
    local path = vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/")
    local handle = vim.uv.fs_scandir(path)

    while handle do
        local name = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end
        if name:find("%.lua$") then
            list[#list + 1] = (dir ~= "" and dir .. "." or "") .. name:match("(.+)%.lua$")
        end
    end

    return list
end

---@param opts? vim.pack.keyset.add | { dir: string|string[] }
M.setup = function(opts)
    opts = opts or {}

    local dir = opts.dir
    local modlist = {} ---@type string[]

    if dir then
        if type(dir) == "string" then
            modlist = require_list(dir)
        else
            for _, d in ipairs(dir) do
                modlist = vim.tbl_extend("force", modlist, require_list(d))
            end
        end
    else
        return
    end

    local speclist = {} ---@type vim.pack.Spec[]
    for _, mod in ipairs(modlist) do
        local spec = require(mod) ---@type vim.pack.Spec | utils.pack.Data
        -- stylua: ignore
        speclist[#speclist + 1] = {
            src     = spec.src,
            name    = spec.name,
            version = spec.version,

            data = { ---@type utils.pack.Data
                lazy   = spec.lazy,
                module = spec.module,
                opts   = spec.opts,
                config = spec.config,
            },
        }
    end

    M._spec = {}

    vim.pack.add(speclist, {
        confirm = opts.confirm or true,
        load = function(pack)
            local spec = pack.spec ---@type vim.pack.SpecResolved
            local path = pack.path
            local data = spec.data ---@type utils.pack.Data

            M._spec[spec.name] = spec

            local lazy = data.lazy

            local pack_dependency = data.dependency -- TODO
            local pack_module = data.module or spec.name:match("(.+)%.nvim$") or spec.name
            local pack_opts = data.opts and (type(data.opts) == "function" and data.opts() or data.opts) --[[@as table?]]
                or {}

            if lazy then
                local lazy_augroup = vim.api.nvim_create_augroup("PackLazy:" .. spec.name, { clear = true })

                ---@param package_opts table?
                local config = function(package_opts)
                    vim.opt.rtp:prepend(path)
                    pcall(data.config or require(pack_module).setup --[[@as fun(opts?: table)]], package_opts)
                    pcall(vim.api.nvim_del_augroup_by_id, lazy_augroup)
                end

                if lazy.event then
                    vim.api.nvim_create_autocmd(lazy.event, {
                        group = lazy_augroup,
                        once = true,
                        callback = function()
                            config(pack_opts)
                        end,
                    })
                end

                if lazy.ft then
                    vim.api.nvim_create_autocmd("FileType", {
                        group = lazy_augroup,
                        once = true,
                        pattern = lazy.ft,
                        callback = function()
                            config(pack_opts)
                        end,
                    })
                end

            -- if lazy.cmd then end -- TODO
            else
                vim.opt.rtp:prepend(path)
                pcall(data.config or require(pack_module).setup --[[@as fun(opts?: table)]], pack_opts)
            end
        end,
    })
end

return M
