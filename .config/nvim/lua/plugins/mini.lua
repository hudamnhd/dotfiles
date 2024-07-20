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
      miniclue.gen_clues.g(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
    },
    triggers = {
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
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

  require("mini.completion").setup({})

  vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "+", change = "~", delete = "-" },
    },
  })

  require("mini.pairs").setup({
    mappings = {
      ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
      [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
    },
  })

  require("mini.operators").setup({})

  require("mini.align").setup({
    mappings = {
      start = "=",
      start_with_preview = "+",
    },
  })

  require("mini.bracketed").setup({
    buffer = { suffix = "", options = {} },
  })

  local function get_buffer_index(buf_id)
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    for i, buffer in ipairs(buffers) do
      if buffer.bufnr == buf_id then
        return i
      end
    end
    return -1
  end

  -- Example usage in your format function
  require("mini.tabline").setup({
    format = function(buf_id, label)
      local suffix = vim.bo[buf_id].modified and "+ " or ""
      local buffer_index = get_buffer_index(buf_id)
      return " " .. buffer_index .. "." .. MiniTabline.default_format(buf_id, label) .. suffix
    end,
  })

      -- stylua: ignore start
  vim.api.nvim_set_hl(0, "MiniTablineCurrent", { fg = "#343D46", bg = "#eeeeee", bold = true })
  vim.api.nvim_set_hl(0, "MiniTablineVisible", { fg = "#eeeeee", bg = "#343D46", bold = true })
  vim.api.nvim_set_hl(0, "MiniTablineHidden", { fg = "#eeeeee", bg = "#343D46", bold = false })
  vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { fg = "#F9AE58", bg = "#000000", bold = true })
  vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { fg = "#000000", bg = "#F9AE58", bold = true })
  vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { fg = "#000000", bg = "#F9AE58", bold = true })
  vim.api.nvim_set_hl(0, "MiniTablineTabpagesection", { fg = "#eeeeee", bg = "#343D46", bold = true })
  -- stylua: ignore end

  require("mini.notify").setup({})
  vim.notify = require("mini.notify").make_notify()

  require("mini.trailspace").setup({})
  require("mini.move").setup({})
  require("mini.extra").setup({})

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

  vim.cmd([[
          highlight MiniHipatternsFixme guibg=#ff5555 guifg=#ffffff
          highlight MiniHipatternsHack guibg=#ffb86c guifg=#000000
          highlight MiniHipatternsTodo guibg=#f1fa8c guifg=#000000
          highlight MiniHipatternsNote guibg=#8be9fd guifg=#000000
        ]])
end

return M
