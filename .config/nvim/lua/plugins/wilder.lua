return {
  "gelguy/wilder.nvim",
  event = "VeryLazy",
  build = function()
    vim.cmd("UpdateRemotePlugins")
  end,
  config = function()
    -- require("wilder").setup({ modes = { ":", "/", "?" } })
    vim.opt.wildmenu = false -- disable wildmenu because wilder is enough
    local wilder = require("wilder")
    wilder.setup({
      modes = { ":", "/", "?" },
    })

    vim.cmd([[
            cmap <expr> <C-N> wilder#in_context() ? wilder#next() : "\<Tab>"
            cmap <expr> <C-P> wilder#in_context()  ? wilder#previous()  : "\<S-Tab>"
    ]])

    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        -- left = { " ", wilder.popupmenu_devicons() },
        -- right = { " ", wilder.popupmenu_scrollbar() },
      })
    )
  end,
}
