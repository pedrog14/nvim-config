return {
  "Bekaboo/dropbar.nvim",
  dependencies = "nvim-mini/mini.icons",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = function()
    local symbols = {
      BlockMappingPair = " ",
      BreakStatement = " ",
      Call = " ",
      CaseStatement = " ",
      ContinueStatement = " ",
      Copilot = " ",
      Declaration = " ",
      Delete = " ",
      DoStatement = " ",
      Element = " ",
      ForStatement = " ",
      GotoStatement = " ",
      Identifier = " ",
      IfStatement = " ",
      List = " ",
      Log = " ",
      Lsp = " ",
      Macro = " ",
      Pair = " ",
      Regex = " ",
      Repeat = " ",
      Return = " ",
      Rule = " ",
      RuleSet = " ",
      Scope = " ",
      Section = " ",
      Specifier = " ",
      Statement = " ",
      SwitchStatement = " ",
      Table = " ",
      Terminal = " ",
      Type = " ",
      WhileStatement = " ",
    }

    local symbol_kind = vim.lsp.protocol.SymbolKind
    for _, kind in ipairs(symbol_kind) do
      local icon = MiniIcons.get("lsp", kind --[[@as string]])
      symbols[kind] = icon .. " "
    end

    local sources = require("dropbar.sources")

    ---@module "dropbar"
    ---@type dropbar_configs_t
    return {
      menu = { preview = false },
      bar = {
        enable = function(buf, win)
          buf = vim._resolve_bufnr(buf)
          if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
            return false
          end

          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo[win].winbar ~= ""
            or vim.bo[buf].ft == "help"
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then
            return false
          end

          return not vim.tbl_isempty(vim.lsp.get_clients({
            bufnr = buf,
            method = "textDocument/documentSymbol",
          }))
        end,
        sources = {
          sources.path,
          sources.lsp,
        },
      },
      icons = {
        kinds = {
          dir_icon = "",
          file_icon = function(path)
            local icon, hl = MiniIcons.get("file", path)
            return icon .. " ", hl
          end,
          symbols = symbols,
        },
        ui = { bar = { separator = "  " }, menu = { indicator = " " } },
      },
    }
  end,
}
