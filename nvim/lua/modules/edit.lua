return {
  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'ds',
      'cs',
      { 'S', mode = 'x' },
      { '<C-g>s', mode = 'i' },
    },
    config = function()
      require('configs.nvim-surround')
    end,
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' } },
      { 'gb', mode = { 'n', 'x' } },
    },
    config = function()
      require('configs.Comment')
    end,
  },

  {
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      require('configs.ultimate-autopair')
    end,
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'gl', mode = { 'n', 'x' } },
      { 'gL', mode = { 'n', 'x' } },
    },
    config = function()
      require('configs.vim-easy-align')
    end,
  },

  {
    'thinca/vim-partedit',
    keys = {
      { '<c-e>', mode = { 'n', 'x' } },
      { '<a-e>', mode = { 'n', 'x' } },
    },
    config = function()
      vim.keymap.set({ 'n', 'x' }, '<c-e>', ':Partedit<CR>')
      vim.keymap.set({ 'n', 'x' }, '<a-e>', ':ParteditEnd<CR>')
    end,
  },

  {
    'thinca/vim-qfreplace',
    ft = 'qf',
    config = function()
      vim.keymap.set({ 'n', 'x' }, 'rq', ':Qfreplace<CR>')
    end,
  },

  {
    'kshenoy/vim-signature',
    event = { 'BufReadPost' },
  },

  {
    'AckslD/nvim-neoclip.lua',
    keys = { 'sy' },
    dependencies = {
      { 'kkharji/sqlite.lua', module = 'sqlite' },
      { 'ibhagwan/fzf-lua' },
    },
    config = function()
      require('neoclip').setup({
        history = 1000,
        enable_persistent_history = true,
        db_path = vim.fn.stdpath('data') .. '/databases/neoclip.sqlite3',
        length_limit = 1048576,
        continuous_sync = false,
        filter = nil,
        preview = true,
        prompt = nil,
        default_register = '"',
        default_register_macros = 'q',
        enable_macro_history = true,
        content_spec_column = false,
        disable_keycodes_parsing = true,
        keys = {
          fzf = {
            select = 'default',
            paste = 'ctrl-p',
            paste_behind = 'ctrl-l',
            custom = {},
          },
        },
      })

      vim.keymap.set('n', 'sy', "<CMD>lua require('neoclip.fzf')() <CR>")
    end,
  },

  {
    'mbbill/undotree',
    keys = { 'tu' },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.keymap.set(
        'n',
        'tu',
        vim.cmd.UndotreeToggle,
        { desc = 'Undotree Toggle' }
      )
    end,
  },

  {
    'smoka7/hop.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('configs.hop')
    end,
  },
}
