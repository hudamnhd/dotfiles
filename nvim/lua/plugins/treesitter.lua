return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost" },
    build = ":TSUpdate",
    -- dependencies = { "RRethy/nvim-treesitter-endwise" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "lua",
          "c",
          "cpp",
          "php",
          "json",
          "vim",
          "jsonc",
          "jsdoc",
          "html",
          "typescript",
          "tsx",
          "javascript",
        },
        ignore_install = { "comment" },

        highlight = {
          enable = true,
          disable = function(lang, buf)
            -- disable highlighting for certain file types
            -- help     : https://github.com/nvim-treesitter/nvim-treesitter/pull/3555
            -- vimdoc   : same as the "old" help filetype
            if vim.tbl_contains({ "help", "vimdoc" }, lang) then
              return true
            end

            -- disable highlighting for big markdown files (bad performance)
            if lang == "markdown" and vim.api.nvim_buf_line_count(buf) > 3000 then
              return true
            end

            -- disable highlighting for large buffers
            if vim.api.nvim_buf_line_count(buf) > 10000 then
              return true
            end

            return false
          end,
        },

        matchup = {
          enable = true,
        },
      })
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<leader>j", "<leader>J" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      local tsj = require("treesj")

      tsj.setup({
        use_default_keymaps = false,
        max_join_length = 1024,
      })
      ---@param preset table?
      ---@return nil
      -- For use default preset and it work with dot
      vim.keymap.set("n", "<leader>j", require("treesj").toggle, { desc = "Toggle Join" })
      -- For extending default preset with `recursive = true`, but this doesn't work with dot
      vim.keymap.set("n", "<leader>J", function()
        require("treesj").toggle({ split = { recursive = true } })
      end, { desc = "Toggle Join recursive" })
    end,
  },
}
