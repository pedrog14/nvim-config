---@class utils.pack.Opts: vim.pack.keyset.add
---@field load (boolean|fun(plug_data: { spec: utils.pack.SpecResolved, path: string }))?
---@field path (string|string[])? Path of pack specs (`:h vim.pack.Spec`), same notation as lua modules

---@class utils.pack.Spec: vim.pack.Spec
---@field data utils.pack.Data

---@class utils.pack.SpecResolved: vim.pack.Spec
---@field data utils.pack.DataResolved

---@class utils.pack.Data
---@field module string?
---@field opts   (table|fun(): table)?
---@field config fun(opts: table?)?
---@field lazy   utils.pack.Lazy?

---@class utils.pack.DataResolved: utils.pack.Data
---@field module string
---@field opts   table?
---@field config fun(opts: table?)

---@class utils.pack.Lazy
---@field cmd   (string|string[])?
---@field event (vim.api.keyset.events|vim.api.keyset.events[])?

local M = {}

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

M.spec = nil ---@type utils.pack.Spec[]?

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

  M.spec = vim.tbl_map(function(spec) ---@param spec vim.pack.Spec|utils.pack.Data
    ---@type utils.pack.Spec
    -- stylua: ignore
    return {
      src     = spec.src,
      name    = spec.name,
      version = spec.version,
      data = {
        lazy   = spec.lazy,
        module = spec.module,
        config = spec.config,
        opts   = spec.opts,
      },
    }
  end, M.get_spec(path))

  local confirm = pack_opts.confirm or true

  local load = pack_opts.load
    or function(plug_data) ---@param plug_data { spec: utils.pack.SpecResolved, path: string }
      local spec = plug_data.spec
      local data = spec.data

      data.module = data.module or spec.name:gsub("%.nvim$", "")
      data.opts = type(data.opts) == "function" and data.opts() or data.opts
      data.config = data.config
        or function(opts) ---@param opts table?
          require(data.module).setup(opts)
        end

      if data.lazy then
        for key, value in pairs(data.lazy) do
          require("utils.pack.lazy." .. key).load(value, spec)
        end
      else
        M.load(spec)
      end
    end

  vim.pack.add(M.spec, { confirm = confirm, load = load })
end

return M
