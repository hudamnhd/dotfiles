local M = {
  "echasnovski/mini.nvim",
  version = "*",
  event = { "VeryLazy" },
}

function M.config()
  local mapping = require("keymaps")
  local miniclue = require("mini.clue")
  local anchor = "SW" -- bottom-left

  --stylua: ignore
  miniclue.setup({
    clues = {
      mapping.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
    },
    triggers = {
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'n', keys = 's' },        -- `s` key
      { mode = 'n', keys = "'" },        -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },        -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },    -- Window commands
      { mode = 'i', keys = '<C-x>' },    -- Built-in completion
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
    },
    window = {
      delay = 0,
      config = {
        border = 'double',
        anchor = anchor,
        width = 'auto',
        row = 'auto',
        col = 'auto' ,
      },
    },
  })

  require("mini.diff").setup({
    view = { signs = { add = "+", change = "~", delete = "-" } },
  })

  require("mini.pairs").setup({
    mappings = {
      ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
      [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
    },
  })

  require("mini.operators").setup({
    replace = { prefix = "r" },
    exchange = { prefix = "ge" },
  })

  require("mini.align").setup({
    mappings = {
      start = "=",
      start_with_preview = "+",
    },
  })

  require("mini.bracketed").setup({
    buffer = { suffix = "", options = {} },
  })

  require("mini.notify").setup({})
  vim.notify = require("mini.notify").make_notify()

  require("mini.trailspace").setup({})
  require("mini.visits").setup({})
  require("mini.move").setup({})
  require("mini.extra").setup({})

  require("mini.pick").setup({
    mappings = {
      choose_marked = "<a-q>",
      move_down = "<C-j>",
      move_up = "<C-k>",
      toggle_preview = "<C-P>",
      mark = "<Tab>",
      mark_all = "<a-a>",
    },
    options = {
      use_cache = true,
    },
  })

  require("mini.surround").setup({
    custom_surroundings = {
      s = {
        -- 'ysiws'  foo -> [[foo]]
        input = { "%[%[().-()%]%]" },
        output = { left = "[[", right = "]]" },
      },
      j = {
        input = { "%{%/%*().-()%*%/%}" },
        output = { left = "{/*", right = "*/}" },
      },
      b = {
        input = { "%{%{%-%-().-()%-%-%}%}" },
        output = { left = "{{--", right = "--}}" },
      },
      h = {
        input = { "%<%!%-%-().-()%-%-%>" },
        output = { left = "<!--", right = "-->" },
      },
    },
    mappings = {
      add = "ys",
      delete = "ds",
      find = "",
      find_left = "",
      highlight = "", -- hijack 'gs' (sleep) for highlight
      replace = "cs",
      update_n_lines = "", -- bind for updating 'config.n_lines'
    },
  })

  -- Remap adding surrounding to Visual mode selection
  vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

  -- unmap config generated `ys` mapping, prevents visual mode yank delay
  if vim.keymap then
    vim.keymap.del("x", "ys")
  else
    vim.cmd("xunmap ys")
  end

  -- Make special mapping for "add surrounding for line"
  vim.keymap.set("n", "yss", "ys_", { remap = true })

  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  -- vim.cmd([[
  --         highlight MiniHipatternsFixme guibg=#ff5555 guifg=#ffffff
  --         highlight MiniHipatternsHack guibg=#ffb86c guifg=#000000
  --         highlight MiniHipatternsTodo guibg=#f1fa8c guifg=#000000
  --         highlight MiniHipatternsNote guibg=#8be9fd guifg=#000000
  --       ]])


  -- require("mini.indentscope").setup({
  --   symbol = "╎",
  --   draw = { animation = require("mini.indentscope").gen_animation.none() },
  -- })

  -- vim.keymap.set("n", "al", "<Cmd>lua MiniVisits.add_label()<CR>")
  -- vim.keymap.set("n", "aL", "<Cmd>lua MiniVisits.remove_label()<CR>")

  -- vim.keymap.set("n", "H", "<Cmd>lua MiniBracketed.buffer('backward')<CR>")
  -- vim.keymap.set("n", "L", "<Cmd>lua MiniBracketed.buffer('forward')<CR>")
end

return M
