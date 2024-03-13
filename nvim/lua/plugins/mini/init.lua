local M = {
  "echasnovski/mini.nvim",
  event = { "BufReadPost" },
}
function M.config()
  require("plugins.mini.surround")
  require("plugins.mini.indentscope")
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
        prefix = "zx",

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
        prefix = "gr",

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

  vim.keymap.set("n", "<a-a>", "gm_", { remap = true })
  vim.keymap.set("v", "<a-a>", "gm", { remap = true })
end

return M
