return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "gqq",
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                "n",
                true
              )
            end
          end
        end)
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      haskell = { "stylish-haskell" },
      sh = { "shfmt" },
      javascript = { "biome" },
      typescript = { "dprint" },
      javascriptreact = { "dprint" },
      typescriptreact = { "dprint" },
      css = { "biome" },
      html = { "biome" },
      json = { "biome" },
      json5 = { "biome" },
      jsonc = { "biome" },
      yaml = { "dprint" },
      -- markdown        = { "dprint" },
      lua = { "stylua" },
      markdown = { "dprint" },
      ["_"] = { "trim_whitespace", "trim_newlines" },
    },
    log_level = vim.log.levels.TRACE,
    format_after_save = function(bufnr)
      if vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 5000, lsp_format = "fallback" }
    end,
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function(_, opts)
    if vim.g.started_by_firenvim then
      opts.format_on_save = false
      opts.format_after_save = false
    end
    require("conform").setup(opts)
  end,
}
