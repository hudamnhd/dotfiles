local M = {
  {
    "echasnovski/mini.surround",
    version = "*",
    event = { "VeryLazy" },

    config = function()
      require("plugins.mini.surround")
    end,
  },
  {
    "echasnovski/mini.operators",
    version = "*",
    event = { "VeryLazy" },
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
            prefix = "ss",

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
    end,
  },
  {
    "echasnovski/mini.move",
    version = "*",
    enabled = false,
    -- event = { "VeryLazy" },
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
-- function M.config()
  -- require("plugins.mini.indentscope")
-- end

return M
