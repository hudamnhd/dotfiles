local M = {
  "echasnovski/mini.nvim",
  version = "*",
  event = "VeryLazy",
}

function M.config()
  require("mini.icons").setup()
  require("mini.colors").setup()
  vim.g.nvim_web_devicons = 1
  MiniIcons.mock_nvim_web_devicons()

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
      { mode = 'i', keys = '<C-x>' },    -- Built-in completion
      { mode = 'n', keys = '<space>' }, -- space triggers
      { mode = 'x', keys = '<space>' },
      { mode = 'n', keys = '<space>' }, -- space triggers
      { mode = 'x', keys = '<space>' },
      { mode = 'n', keys = '\\' }, -- space triggers
      { mode = 'x', keys = '\\' },
      { mode = 'n', keys = '<C-a>' },    -- Window commands
      { mode = 'x', keys = '<C-a>' },    -- Window commands
    },
    window = {
      delay = 0,
      config = {
        border = 'single',
        anchor = anchor,
        width = 'auto',
        row = 'auto',
        col = 'auto' ,
        -- col = vim.o.columns * 0.4,
        -- row = vim.o.lines - 2,
      },
    },
  })

  -- require("mini.completion").setup({})
  --
  -- vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  -- vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

  require("mini.diff").setup({

    view = {
      style = "sign",
      -- signs = { add = " ", change = " ", delete = "" },
      signs = { add = "+", change = "~", delete = "-" },
      -- signs = { add = "█", change = "█", delete = "█" },
      priority = 100,
    },
  })

  require("mini.pairs").setup({
    modes = { insert = true, command = false, terminal = false },
    mappings = {
      ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
      [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
    },
  })

  require("mini.operators").setup({
    sort = {
      prefix = "",
      func = nil,
    },
  })

  -- require("mini.statusline").setup()

  -- stylua: ignore end
  require("mini.bracketed").setup({
    buffer = { suffix = "", options = {} },
    -- quickfix = { suffix = "", options = {} },
  })

  local map = vim.keymap.set
  map("n", "<C-T>", "<Cmd>lua MiniBracketed.buffer('backward')<CR>")
  map("n", "<C-Y>", "<Cmd>lua MiniBracketed.buffer('forward')<CR>")
  --
  require("mini.notify").setup({
    lsp_progress = {
      -- oh god please stop annoying me
      enable = false,
    },

    window = {
      -- https://github.com/echasnovski/mini.nvim/blob/a118a964c94543c06d8b1f2f7542535dd2e19d36/doc/mini-notify.txt#L186-L198
      config = {
        anchor = "SE",
        col = vim.o.columns * 0.5,
        row = vim.o.lines - 2,
        -- width = math.floor(vim.o.columns * 0.6),
        border = "single",
      },
      winblend = 10,
    },
  })
  vim.notify = require("mini.notify").make_notify()

  require("mini.splitjoin").setup({ mappings = { toggle = "gs" } })

  require("mini.trailspace").setup({})
  require("mini.move").setup({})
  require("mini.extra").setup({})

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
      highlight = "", -- hijack 'gs' (sleep) for highlight
      replace = "cs",
      update_n_lines = "", -- bind for updating 'config.n_lines'
    },
  })

  -- Remap adding surrounding to Visual mode selection
  --stylua: ignore
  vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true, desc = "MiniSurround add visual" })

  -- unmap config generated `ys` mapping, prevents visual mode yank delay
  if vim.keymap then
    vim.keymap.del("x", "ys")
  else
    vim.cmd("xunmap ys")
  end

  -- Make special mapping for "add surrounding for line"
  vim.keymap.set("n", "yss", "ys_", { remap = true })
end

return M
