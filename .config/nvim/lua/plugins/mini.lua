local M = {
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = { "InsertEnter" },
    config = function()
      require("mini.pairs").setup(
        -- No need to copy this inside `setup()`. Will be used automatically.
        {
          -- In which modes mappings from this `config` should be created
          modes = { insert = true, command = false, terminal = false },

          -- Global mappings. Each right hand side should be a pair information, a
          -- table with at least these fields (see more in |MiniPairs.map|):
          -- - <action> - one of 'open', 'close', 'closeopen'.
          -- - <pair> - two character string for pair to be used.
          -- By default pair is not inserted after `\`, quotes are not recognized by
          -- `<CR>`, `'` does not insert pair after a letter.
          -- Only parts of tables can be tweaked (others will use these defaults).
          mappings = {
            ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
            ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
            ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
            ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

            [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
            [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
            ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
            ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

            ['"'] = {
              action = "closeopen",
              pair = '""',
              neigh_pattern = "[^\\].",
              register = { cr = false },
            },
            ["'"] = {
              action = "closeopen",
              pair = "''",
              neigh_pattern = "[^%a\\].",
              register = { cr = false },
            },
            ["`"] = {
              action = "closeopen",
              pair = "``",
              neigh_pattern = "[^\\].",
              register = { cr = false },
            },
          },
        }
      )
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    version = "*",
    keys = "<F12>",
    config = function()
      vim.keymap.set("n", "<F12>", ":lua MiniHipatterns.toggle()<CR>", {})

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
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    event = { "BufReadPost" },

    config = function()
      require("mini.surround").setup({
        -- vim-surround style mappings
        -- left brackets add space around the text object
        -- 'ysiw('    foo -> ( foo )
        -- 'ysiw)'    foo ->  (foo)
        custom_surroundings = {
          -- since mini.nvim#84 we no longer need to customize
          -- the left brackets, they are spaced by default
          -- https://github.com/echasnovski/mini.nvim/issues/84
          s = {
            -- lua bracketed string mapping
            -- 'ysiwS'  foo -> [[foo]]
            input = { "%[%[().-()%]%]" },
            output = { left = "[[", right = "]]" },
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
        -- Number of lines within which surrounding is searched
        n_lines = 62,
        -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        highlight_duration = 2000,
        -- How to search for surrounding (first inside current line, then inside
        -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
        search_method = "cover_or_next",
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
    end,
  },
  {
    "echasnovski/mini.operators",
    version = "*",
    event = { "BufReadPost" },
    config = function()
      require("mini.operators").setup( -- No need to copy this inside `setup()`. Will be used automatically.
        {
          -- Each entry configures one operator.
          -- `prefix` defines keys mapped during `setup()`: in Normal mode
          -- to operate on textobject and line, in Visual - on selection.

          -- Evaluate text and replace with output
          evaluate = {
            prefix = "g=",

            -- Function which does the evaluation
            func = nil,
          },

          -- Exchange text regions
          exchange = {
            prefix = "ge",

            -- Whether to reindent new text to match previous indent
            reindent_linewise = true,
          },

          -- Multiply (duplicate) text
          multiply = {
            prefix = "gm",

            -- Function which can modify text before multiplying
            func = nil,
          },

          -- Replace text with register
          replace = {
            prefix = "r",

            -- Whether to reindent new text to match previous indent
            reindent_linewise = true,
          },

          -- Sort text
          sort = {
            prefix = "gz",

            -- Function which does the sort
            func = nil,
          },
        }
      )
      vim.keymap.set("n", "K", "Vgm", { remap = true })
      vim.keymap.set("n", "X", "geiw", { remap = true })
      vim.keymap.set("n", "S", "ysiw", { remap = true })
    end,
  },
  {
    "echasnovski/mini.move",
    version = "*",
    -- enabled = false,
    event = { "BufReadPost" },
    config = function()
      require("mini.move").setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
          left = "<M-h>",
          right = "<M-l>",
          down = "<M-j>",
          up = "<M-k>",

          -- Move current line in Normal mode
          line_left = "<M-h>",
          line_right = "<M-l>",
          line_down = "<M-j>",
          line_up = "<M-k>",
        },

        options = {
          reindent_linewise = false,
        },
      })
    end,
  },
}

return M
