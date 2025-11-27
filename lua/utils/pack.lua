---@class utils.pack.Opts: vim.pack.keyset.add
---@field path (string|string[])? Path of pack specs (`:h vim.pack.Spec`), same notation as lua modules

---@class utils.pack.Data
---@field module string?
---@field config fun(opts: table?)?
---@field opts (table|fun(): table)?
---@field lazy utils.pack.Lazy?

---@class utils.pack.Lazy
---@field cmd (string|string[])?
---@field event (vim.api.keyset.events|vim.api.keyset.events[])?

---@class utils.pack.Spec: vim.pack.Spec, utils.pack.Data

---@class utils.pack.SpecResolved: vim.pack.Spec
---@field data utils.pack.Data

local M = {}

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
            local name = vim.uv.fs_scandir_next(stream)
            if not name then
                break
            end
            specs[#specs + 1] = name:match("%.lua$") and require(path .. "." .. name:match("^(.+)%.lua$"))
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

---@param spec utils.pack.SpecResolved
local plug_load = function(spec)
    vim.cmd.packadd(spec.name)
    local data = spec.data
    if data.config then
        data.config(data.opts --[[@as table?]])
    end
end

---@param cmd string
---@param spec utils.pack.SpecResolved
local command_load = function(cmd, spec)
    vim.api.nvim_create_user_command(cmd, function(args)
        local command = {
            cmd = cmd,
            bang = args.bang or nil,
            mods = args.smods,
            args = args.fargs,
            count = args.count >= 0 and args.range == 0 and args.count or nil,
        }

        if args.range == 1 then
            command.range = { args.line1 }
        elseif args.range == 2 then
            command.range = { args.line1, args.line2 }
        end

        vim.api.nvim_del_user_command(cmd)
        plug_load(spec)

        local info = vim.api.nvim_get_commands({})[cmd] or vim.api.nvim_buf_get_commands(0, {})[cmd]

        command.nargs = info.nargs

        if args.args and args.args ~= "" and info.nargs and info.nargs:find("[1?]") then
            command.args = { args.args }
        end

        vim.cmd(command)
    end, {
        bang = true,
        range = true,
        nargs = "*",
        complete = function(_, line)
            vim.api.nvim_del_user_command(cmd)
            plug_load(spec)
            return vim.fn.getcompletion(line, "cmdline")
        end,
    })
end

---@param pack_opts utils.pack.Opts
M.setup = function(pack_opts)
    local path = pack_opts.path

    if not path then
        return
    end

    ---@type vim.pack.Spec[]
    local specs = vim.tbl_map(function(spec) ---@param spec utils.pack.Spec
        return { ---@type utils.pack.SpecResolved
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
    end, get_specs(path))

    ---@param plug_data { spec: utils.pack.SpecResolved, path: string }
    local load = function(plug_data)
        local spec = plug_data.spec
        local data = spec.data

        ---@type string
        data.module = data.module or spec.name:gsub("%.nvim$", "")
        ---@type table
        data.opts = type(data.opts) == "function" and data.opts() or data.opts --[[@as table]]
        ---@type fun(opts: table?)|nil
        data.config = data.config == nil
                and data.opts
                and function(opts) ---@param opts table?
                    require(data.module).setup(opts)
                end
            or data.config

        local lazy = data.lazy
        if lazy then
            if lazy.event then
                vim.api.nvim_create_autocmd(lazy.event, {
                    once = true,
                    callback = function()
                        plug_load(spec)
                    end,
                })
            end
            if lazy.cmd then
                if type(lazy.cmd) == "table" then
                    for _, value in
                        ipairs(lazy.cmd --[[@as string[] ]])
                    do
                        command_load(value, spec)
                    end
                else
                    command_load(lazy.cmd --[[@as string]], spec)
                end
            end
        else
            plug_load(spec)
        end
    end

    vim.pack.add(specs, { confirm = pack_opts.confirm or true, load = pack_opts.load or load })
end

return M
