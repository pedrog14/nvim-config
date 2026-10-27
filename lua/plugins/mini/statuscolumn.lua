return {
  "nvim-mini/mini.statuscolumn",
  event = "VeryLazy",
  opts = function()
    local statuscolumn = require("mini.statuscolumn")
    return {
      content = statuscolumn.gen_content.main({
        { format = "s=lf", sep = "" },
        { ltype = "virt", lnum = "•" },
        { ltype = "wrap", lnum = "↳" },
        { ltype = "text", sign = "%s", lnum = "%l", fold = " %C " },
      }),
      dim_inactive = false,
    }
  end,
}
