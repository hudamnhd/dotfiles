return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "cpp",
          "html",
          "json",
          "prisma",
          "solidity",
          "tsx",
          "typescript",
          "php",
          "php_only",
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
              return false
            end

            -- disable highlighting for big markdown files (bad performance)
            if lang == "markdown" and vim.api.nvim_buf_line_count(buf) > 3000 then
              return false
            end

            -- disable highlighting for large buffers
            if vim.api.nvim_buf_line_count(buf) > 10000 then
              return false
            end

            return false
          end,
        },

        matchup = {
          enable = false,
        },
      })

       local all_lang = {
         "cpp",
         "json",
         "php",
         "html",
         "tsx",
         "javascriptreact",
         "typescript",
         "typescriptreact",
       }

       -- vim.treesitter.language.register("javascript", all_lang)
        vim.treesitter.language.register("php_only", "php")
        vim.treesitter.language.register("javascript", "blade")
    end,
  },
}
