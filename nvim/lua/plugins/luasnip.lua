return {
  "L3MON4D3/LuaSnip",
  event = "BufReadPost",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
