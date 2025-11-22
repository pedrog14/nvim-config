---@class utils.pack.opts: vim.pack.keyset.add
---@field path? string|string[] Path of pack `specs` (`vim.pack.Spec`), same notation as lua modules

---@class utils.pack.Data
---@field module? string
---@field config? fun(opts?: table)
---@field opts? table|fun(): table

---@alias utils.pack.Spec vim.pack.Spec|utils.pack.Data

local M = {}

local _installed = nil ---@type string[]?

---@param spec_path string|string[]
---@return vim.pack.Spec[]
local get_specs = function(spec_path)
    ---@param path string
    ---@return vim.pack.Spec[]
    local require_spec = function(path)
        local specs = {} ---@type vim.pack.Spec[]
        local pathstr = vim.fn.stdpath("config") .. "/lua/" .. path:gsub("%.", "/")
        local stream = vim.uv.fs_scandir(pathstr)

        while stream ~= nil do
            local name, _ = vim.uv.fs_scandir_next(stream)

            if not name then
                break
            end

            if name:match("%.lua$") then
                specs[#specs + 1] = require(path .. "." .. name:gsub("%.lua$", ""))
            end
        end

        return specs
    end

    local specs = nil

    if type(spec_path) == "table" then
        for _, pathstr in ipairs(spec_path) do
            specs = vim.tbl_deep_extend("force", specs or {}, require_spec(pathstr))
        end
    else
        specs = require_spec(spec_path)
    end

    return specs
end

M.get_installed = function()
    return _installed or {}
end

---@param opts utils.pack.opts
M.setup = function(opts)
    local path = opts.path
    if not path then
        return
    end

    ---@type vim.pack.Spec[]
    local specs = vim.tbl_map(function(spec) ---@param spec utils.pack.Spec
        return { ---@type vim.pack.Spec
            src = spec.src,
            name = spec.name,
            version = spec.version,
            data = { ---@type utils.pack.Data
                module = spec.module,
                config = spec.config,
                opts = spec.opts,
            },
        }
    end, get_specs(path))

    local confirm = opts.confirm or true
    local load = opts.load
        ---@param pack_data { spec: vim.pack.SpecResolved|{ data: utils.pack.Data }, path: string }
        or function(pack_data)
            local spec = pack_data.spec
            local data = spec.data

            local name = spec.name

            _installed = _installed or {}
            _installed[#_installed + 1] = name

            local module = data.module or name:gsub("%.nvim$", "")

            local lazy = data.lazy

            -- package.preload[module] = function()
            --     vim.cmd.packadd(name)
            -- package.searchpath
            -- end

            if not lazy then
                local pack_setup = data.config
                    or data.opts
                        and function(pack_opts)
                            require(module).setup(pack_opts)
                        end

                if pack_setup then
                    pack_setup(data.opts)
                end

                package.preload[module] = nil
            else
            end
        end

    vim.pack.add(specs, { confirm = confirm, load = load })
end

return M
