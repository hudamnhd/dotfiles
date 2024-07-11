return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      -- stylua: ignore start
      formatters_by_ft = {
        javascript      = { "biome" },
        typescript      = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        svelte          = { "biome" },
        css             = { "biome" },
        html            = { "biome" },
        json            = { "biome" },
        markdown        = { "biome" },
        lua             = { "stylua" },
        -- stylua: ignore end
      },
    })
  end,
}
