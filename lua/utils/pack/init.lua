---@class utils.pack.Opts: vim.pack.keyset.add
---@field load (boolean|fun(plug_data: { spec: utils.pack.SpecResolved, path: string }))?
---@field path (string|string[])? Path of pack specs (`|vim.pack.Spec|`), same notation as lua modules

---@class utils.pack.Spec: vim.pack.Spec
---@field data utils.pack.Data

---@class utils.pack.SpecResolved: vim.pack.Spec
---@field data utils.pack.DataResolved

---@class utils.pack.Data
---@field priority integer?
---@field module   string?
---@field opts     (table|fun(): table)?
---@field config   fun(opts: table?)?
---@field lazy     utils.pack.Lazy?

---@class utils.pack.DataResolved: utils.pack.Data
---@field module string
---@field opts   table?
---@field config fun(opts: table?)

---@class utils.pack.Lazy
---@field cmd   (string|string[])?
---@field event (vim.api.keyset.events|vim.api.keyset.events[])?

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

local M = {}

M.packages = nil ---@type table<string, vim.pack.PlugData>

---@param path string|string[]
---@return table
M.get_spec = function(path)
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

  local spec = vim.tbl_map(function(spec) ---@param spec vim.pack.Spec|utils.pack.Data
    ---@type utils.pack.Spec
    -- stylua: ignore
    return {
      src     = spec.src,
      name    = spec.name or spec.src:gsub("%.git$", ""):match("([^/]+)$"),
      version = spec.version,
      data = {
        priority = spec.priority,
        module   = spec.module,
        config   = spec.config,
        opts     = spec.opts,
        lazy     = spec.lazy,
      },
    }
  end, M.get_spec(path))

  local default_priority = 100

  table.sort(spec, function(a, b)
    local priority_a = a.data.priority or default_priority
    local priority_b = b.data.priority or default_priority

    return priority_a > priority_b
  end)

  local confirm = pack_opts.confirm or true

  local load = pack_opts.load
    or function(plug_data) ---@param plug_data { spec: utils.pack.SpecResolved, path: string }
      local plug_spec = plug_data.spec
      local data = plug_spec.data

      data.module = data.module or plug_spec.name:gsub("%.nvim$", "")
      data.opts = type(data.opts) == "function" and data.opts() or data.opts
      data.config = data.config
        or function(opts) ---@param opts table?
          require(data.module).setup(opts)
        end

      if data.lazy then
        for key, value in pairs(data.lazy) do
          require("utils.pack.lazy." .. key).load(value, plug_spec)
        end
      else
        M.load(plug_spec)
      end
    end

  vim.pack.add(spec, { confirm = confirm, load = load })

  M.packages = {}

  for _, pack in ipairs(vim.pack.get()) do
    local name = pack.spec.name

    M.packages[name] = pack
  end

  vim.api.nvim_create_user_command("Pack", function(cmd_args)
    local args = cmd_args.fargs
    local option = table.remove(args, 1)

    local specs = {}

    for name, pack in pairs(M.packages) do
      specs[#specs + 1] = vim.tbl_contains(args, name) and pack.spec
    end

    if option == "load" then
      for _, value in ipairs(specs) do
        M.load(value)
      end
    elseif option == "update" then
      vim.pack.update(#args > 0 and args or nil)
    end
  end, {
    nargs = "+",
    complete = function(_, cmdline)
      local cmd_args = vim.split(cmdline, " ", { trimempty = true })

      if #cmd_args == 1 then
        return { "load", "update" }
      elseif #cmd_args == 2 then
        return vim.tbl_keys(M.packages)
      end
    end,
  })
end

return M
