return {
  module = 'mini.notify',
  config = function()
    -- taken from: https://github.com/echasnovski/nvim/blob/5f170054662940d5e2f8badbe816996a8ec744dd/plugin/20_mini.lua#L35
    local notify = require('mini.notify')
    local predicate = function(notif)
      if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
      -- Filter out some LSP progress notifications from 'lua_ls'
      return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
    end
    local custom_sort = function(notif_arr) return notify.default_sort(vim.tbl_filter(predicate, notif_arr)) end

    notify.setup({ content = { sort = custom_sort } })
    vim.notify = notify.make_notify()
  end,
}
