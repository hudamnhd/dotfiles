return {

  "gelguy/wilder.nvim",
  event = "CmdlineEnter",
  build = function()
    vim.cmd("UpdateRemotePlugins")
  end,
  config = function()
    require("wilder").setup({ modes = { ":", "/", "?" } })
    vim.opt.wildmenu = false -- disable wildmenu because wilder is enough
  end,
}
