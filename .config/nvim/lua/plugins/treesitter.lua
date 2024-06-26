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
          "javascript",
        },
        ignore_install = { "comment" },

        highlight = {
          enable = true, -- make faster
          disable = function(lang, buf)
            local max_filesize = 250 * 1024 -- 00 KB
            local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end

            return false
          end,
        },
      })
    end,
  },
}
