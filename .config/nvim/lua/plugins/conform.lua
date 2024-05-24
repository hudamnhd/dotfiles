return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")
    local util = require("conform.util")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        svelte = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        markdown = { "prettierd" },
        -- php = { "blade-formatter" },
        lua = { "stylua" },
      },

      formatters = {
        injected = { options = { ignore_errors = true } },
        blade = {
          meta = {
            url = "https://github.com/shufo/blade-formatter",
            description = "An opinionated blade template formatter for Laravel that respects readability.",
          },
          command = "blade-formatter",
          args = { "--stdin" },
          stdin = true,
          cwd = util.root_file({ "composer.json", "composer.lock" }),
        },
      },
    })
  end,
}
