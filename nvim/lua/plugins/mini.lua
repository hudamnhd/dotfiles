local M = {
  "echasnovski/mini.nvim",
  version = "*",
  enabled = true,
  event = "VimEnter",
}

function M.config()
  require('mini.icons').setup()
  require('mini.icons').mock_nvim_web_devicons()
  require("mini.operators").setup()
  require("mini.splitjoin").setup()
  require("mini.comment").setup()
  require("mini.extra").setup()
  require("mini.bracketed").setup()
  require("mini.basics").setup()
  require("mini.ai").setup()
  require("mini.tabline").setup()
  require("mini.tabline").setup()
  require("mini.bufremove").setup()



  require("mini.align").setup(
    {
      mappings = {
        start = 'sga',
        start_with_preview = 'sgA',
      },
    }
  )

  require("mini.move").setup({
    options = {
      reindent_linewise = false,
    },
  })

  require("mini.pairs").setup({
    modes = { insert = true, command = false, terminal = false },
    mappings = {
      ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
      [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
    },
  })

  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "+", change = "~", delete = "-" },
    },
  })

  local hipatterns = require("mini.hipatterns")

  -- See :help MiniHipatterns.config
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

  local miniclue = require("mini.clue")

  -- See :help MiniClue.config
  miniclue.setup({
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<space>' },
      { mode = 'x', keys = '<space>' },
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = 's' },
      { mode = 'x', keys = 's' },
      { mode = 'n', keys = [[\]] },
      { mode = 'x', keys = [[\]] },
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    window = {
      delay = 0,
      config = {
        border = 'single',
        anchor = 'SW',
        width = 'auto',
        row = 'auto',
        col = 'auto',
      },
    },
  })


  -- See :help MiniNotify.config
  require("mini.notify").setup({
    lsp_progress = {
      enable = false,
    },
  })

  vim.notify = require("mini.notify").make_notify()

  require("mini.surround").setup({
    custom_surroundings = {
      s = {
        input = { "%[%[().-()%]%]" },
        output = { left = "[[", right = "]]" },
      },
      j = {
        input = { "%{%/%*().-()%*%/%}" },
        output = { left = "{/*", right = "*/}" },
      },
      B = {
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
      highlight = "",
      replace = "cs",
      update_n_lines = "",
    },
  })

  -- Remap adding surrounding to Visual mode selection
  --stylua: ignore
  vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add('visual')<CR>]],
    { silent = true, desc = "MiniSurround add visual" })

  -- unmap config generated `ys` mapping, prevents visual mode yank delay
  if vim.keymap then
    vim.keymap.del("x", "ys")
  else
    vim.cmd("xunmap ys")
  end

  -- Make special mapping for "add surrounding for line"
  vim.keymap.set("n", "yss", "ys_", { remap = true })


  local mini_statusline = require('mini.statusline')

  local function statusline()
    local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
    local diagnostics = mini_statusline.section_diagnostics({ trunc_width = 75 })
    local lsp = mini_statusline.section_lsp({ icon = 'LSP', trunc_width = 75 })
    local filename = mini_statusline.section_filename({ trunc_width = 140 })
    local percent = '%2p%%'
    local location = '%3l:%-2c'

    return mini_statusline.combine_groups({
      { hl = mode_hl,                 strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { diagnostics, lsp } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { filename } },
      '%=', -- End left alignment
      { hl = 'MiniStatuslineFilename', strings = { '%{&filetype}' } },
      { hl = 'MiniStatuslineFileinfo', strings = { percent } },
      { hl = mode_hl,                  strings = { location } },
    })
  end

  -- See :help MiniStatusline.config
  mini_statusline.setup({
    content = { active = statusline },

    set_vim_settings = false,
  })
end

return M
