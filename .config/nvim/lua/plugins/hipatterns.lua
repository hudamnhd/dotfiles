return {
  "echasnovski/mini.hipatterns",
  version = "*",
  keys = {
    { "<space>th", ":lua MiniHipatterns.toggle()<CR>", mode = "n", desc = "Hipatterns toggle" },
  },
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })

    vim.cmd([[
 highlight MiniHipatternsFixme guibg=#ff5555 guifg=#ffffff
 highlight MiniHipatternsHack guibg=#ffb86c guifg=#000000
 highlight MiniHipatternsTodo guibg=#f1fa8c guifg=#000000
 highlight MiniHipatternsNote guibg=#8be9fd guifg=#000000
 ]])
  end,
}
