local M = {
  "echasnovski/mini.nvim",
  version = "*",
  enabled = true,
  priority = 1000,
  -- event = "VeryLazy",
  event = "VimEnter",
}

function M.config()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })
  local MiniIcons = require('mini.icons')
  MiniIcons.mock_nvim_web_devicons()
  -- MiniIcons.tweak_lsp_kind()
  require("mini.icons").mock_nvim_web_devicons()
  require("mini.operators").setup()
  require("mini.align").setup()
  require("mini.splitjoin").setup()
  require("mini.comment").setup()
  require("mini.extra").setup()
  require("mini.bracketed").setup()
  require("mini.basics").setup()

  -- require("mini.tabline").setup()
  -- require("mini.statusline").setup()
  -- vim.cmd.colorscheme("neovim_colors")
  require("mini.ai").setup()

  vim.keymap.set({ "o", "x" }, "q", [[iq]], { remap = true })
  vim.keymap.set({ "o", "x" }, "Q", [[aq]], { remap = true })
  vim.keymap.set({ "o", "x" }, "w", [[iw]], { remap = true })
  vim.keymap.set({ "o", "x" }, "W", [[iW]], { remap = true })
  vim.keymap.set({ "o", "x" }, "t", [[it]], { remap = true })
  vim.keymap.set({ "o", "x" }, "T", [[at]], { remap = true })

  vim.keymap.set("n", "sx", [[gxiw]], { remap = true, desc = "Opr 'Exchange word'" })
  vim.keymap.set("n", "sm", [[gmm]], { remap = true, desc = "Opr 'Clone line'" })
  vim.keymap.set("n", "sw", [[ysiw]], { remap = true, desc = "Opr 'Surround word'" })

  -- local process_items = function(items, base)
  --   -- Don't show 'Text' suggestions
  --   items = vim.tbl_filter(function(x) return x.kind ~= 1 end, items)
  --   return require('mini.completion').default_process_items(items, base)
  -- end
  -- require('mini.completion').setup({
  --   lsp_completion = {
  --     source_func = 'omnifunc',
  --     auto_setup = false,
  --     process_items = process_items,
  --   },
  --   window = {
  --     info = { border = 'double' },
  --     signature = { border = 'double' },
  --   },
  -- })
  -- if vim.fn.has('nvim-0.11') == 1 then
  --   vim.opt.completeopt:append('fuzzy') -- Use fuzzy matching for built-in completion
  -- end
  --
  -- vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  -- vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
  --
  -- local snippets, config_path = require('mini.snippets'), vim.fn.stdpath('config')
  --
  -- local lang_patterns = { tex = { 'latex.json' }, plaintex = { 'latex.json' } }
  -- local load_if_minitest_buf = function(context)
  --   local buf_name = vim.api.nvim_buf_get_name(context.buf_id)
  --   local is_test_buf = vim.fn.fnamemodify(buf_name, ':t'):find('^test_.+%.lua$') ~= nil
  --   if not is_test_buf then return {} end
  --   return MiniSnippets.read_file(config_path .. '/snippets/mini-test.json')
  -- end
  --
  -- snippets.setup({
  --   snippets = {
  --     snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
  --     snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
  --     load_if_minitest_buf,
  --   },
  -- })

  require("mini.move").setup({
    mappings = {
      left = "",
      right = "",
      down = "<s-j>",
      up = "<s-k>",

      line_left = "",
      line_right = "",
      line_down = "",
      line_up = "",
    },

    options = {
      reindent_linewise = false,
    },
  })
  require("mini.diff").setup({

    view = {
      style = "sign",
      signs = { add = "+", change = "~", delete = "-" },
    },
  })

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
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<space>' },  -- space triggers
      { mode = 'x', keys = '<space>' },
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = 's' },        -- Leader triggers
      { mode = 'x', keys = 's' },
      { mode = 'n', keys = [[\]] },      -- mini.basics
      { mode = 'x', keys = [[\]] },      -- mini.basics
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' }, -- Built-in completion
      { mode = 'n', keys = 'g' },     -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },     -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' }, -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' }, -- Window commands
      { mode = 'n', keys = 'z' },     -- `z` key
      { mode = 'x', keys = 'z' },
    },
    window = {
      delay = 0,
      config = {
        border = 'single',
        anchor = anchor,
        width = 'auto',
        row = 'auto',
        col = 'auto',
      },
    },
  })

  require("mini.pairs").setup({
    modes = { insert = true, command = false, terminal = false },
    mappings = {
      ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
      [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
    },
  })

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
      highlight = "",      -- hijack 'gs' (sleep) for highlight
      replace = "cs",
      update_n_lines = "", -- bind for updating 'config.n_lines'
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
end

return M
