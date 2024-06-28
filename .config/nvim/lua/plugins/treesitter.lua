return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "FileType" },
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
          "markdown",
        },
        ignore_install = { "comment" },

        highlight = {
          enable = true, -- make faster
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
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
