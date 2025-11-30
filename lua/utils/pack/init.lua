---@class utils.pack.Opts: vim.pack.keyset.add
---@field path (string|string[])? Path of pack specs (`:h vim.pack.Spec`), same notation as lua modules

---@class utils.pack.Spec: vim.pack.Spec
---@field data utils.pack.Data

---@class utils.pack.SpecResolved: vim.pack.Spec
---@field data utils.pack.DataResolved

---@class utils.pack.Data
---@field module string?
---@field config fun(opts: table?)?
---@field opts (table|fun(): table)?
---@field lazy utils.pack.Lazy?

---@class utils.pack.DataResolved: utils.pack.Data
---@field module string
---@field opts table?

---@class utils.pack.Lazy
---@field cmd (string|string[])?
---@field event (vim.api.keyset.events|vim.api.keyset.events[])?

local M = {}

M.spec = nil ---@type utils.pack.Spec[]?

---@param path string|string[]
---@return table
M.get_spec = function(path)
    ---@param spec_path string
    ---@return table
    local require_spec = function(spec_path)
        local spec = {}
        local path_str = vim.fn.stdpath("config") .. "/lua/" .. spec_path:gsub("%.", "/")
        local stream = vim.uv.fs_scandir(path_str)

        while stream ~= nil do
            local name = vim.uv.fs_scandir_next(stream)
            if not name then
                break
            end
            spec[#spec + 1] = name:match("%.lua$") and require(spec_path .. "." .. name:match("^(.+)%.lua$"))
        end

        return spec
    end

    local spec = nil

    if type(path) == "table" then
        for _, spec_path in ipairs(path) do
            spec = vim.tbl_deep_extend("force", spec or {}, require_spec(spec_path))
        end
    else
        spec = require_spec(path)
    end

    return spec
end

---@param spec utils.pack.SpecResolved
M.load = function(spec)
    vim.cmd.packadd(spec.name)
    local data = spec.data
    if data.config then
        data.config(data.opts)
    end
end

---@param pack_opts utils.pack.Opts
M.setup = function(pack_opts)
    local path = pack_opts.path

    if not path then
        return
    end

    M.spec = vim.tbl_map(function(spec) ---@param spec table
        ---@type utils.pack.Spec
        return {
            src = spec.src,
            name = spec.name,
            version = spec.version,
            data = {
                lazy = spec.lazy,
                module = spec.module,
                config = spec.config,
                opts = spec.opts,
            },
        }
    end, M.get_spec(path))

    ---@param data { spec: utils.pack.SpecResolved, path: string }
    local load = function(data)
        local plug_spec = data.spec
        local plug_data = plug_spec.data

        plug_data.module = plug_data.module or plug_spec.name:gsub("%.nvim$", "")
        plug_data.opts = type(plug_data.opts) == "function" and plug_data.opts() or plug_data.opts
        plug_data.config = plug_data.config == nil
                and plug_data.opts ~= nil
                and function(opts) ---@param opts table?
                    require(plug_data.module).setup(opts)
                end
            or plug_data.config

        if plug_data.lazy then
            for key, value in pairs(plug_data.lazy) do
                require("utils.pack.lazy." .. key).load(value, plug_spec)
            end
        else
            M.load(plug_spec)
        end
    end

    vim.pack.add(M.spec, { confirm = pack_opts.confirm or true, load = pack_opts.load or load })
end

return M
