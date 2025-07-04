return {
  module = 'mini.starter',
  lazy = false,
  config = function()
    local starter = require('mini.starter')
    -- See :help MiniStarter-example-config
    starter.sections.quick_access = function()
      return function()
        return {
          { action = 'lua MiniFiles.open()', name = 'Explorer', section = 'Quick Access' },
          { action = 'FzfLua files', name = 'Files', section = 'Quick Access' },
          { action = 'FzfLua grep', name = 'Grep', section = 'Quick Access' },
          { action = 'FzfLua helptags', name = 'Help tags', section = 'Quick Access' },
          { action = 'FzfLua oldfiles', name = 'Old files', section = 'Quick Access' },
          { action = 'F ~/.config/nvim', name = 'Config', section = 'Quick Access' },
        }
      end
    end

    starter.setup({
      items = {
        starter.sections.quick_access(),
        starter.sections.sessions(5, true),
      },
      -- taken from: https://github.com/MaximilianLloyd/ascii.nvim/blob/1f93678874d58b6e51465b31d0c1c90a7008fd42/lua/ascii/text/neovim.lua#L224
      header = [[
                                             
      ████ ██████           █████      ██
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████
    ]],
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning('center', 'center'),
      },
    })
  end,
}
