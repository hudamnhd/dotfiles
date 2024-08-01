return {
  "gelguy/wilder.nvim",
  event = "CmdlineEnter",
  build = function()
    vim.cmd("UpdateRemotePlugins")
  end,
  config = function()
    vim.opt.wildmenu = false -- disable wildmenu because wilder is enough
    local wilder = require("wilder")
    wilder.setup({
      modes = { ":", "/", "?" },
      -- next_key = "<C-N>",
      -- previous_key = "<C-P>",
      -- accept_key = "<tab>",
      -- reject_key = "<s-tab>",
    })
    -- wilder.set_option(
    --   "renderer",
    --   wilder.popupmenu_renderer({
    --     highlighter = wilder.basic_highlighter(),
    --     left = { " ", wilder.popupmenu_devicons() },
    --     right = { " ", wilder.popupmenu_scrollbar() },
    --   })
    -- )
    -- wilder.set_option(
    --   "renderer",
    --   wilder.wildmenu_renderer({
    --     highlighter = wilder.basic_highlighter(),
    --     separator = " · ",
    --     left = { " ", wilder.wildmenu_spinner(), " " },
    --     right = { " ", wilder.wildmenu_index() },
    --   })
    -- )
  end,
}
