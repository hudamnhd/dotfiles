return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('configs.gitsigns')
    end,
  },

  { 'junegunn/gv.vim' },

  {
    'tpope/vim-fugitive',
    cmd = {
      'G',
      'Gcd',
      'Gclog',
      'Gdiffsplit',
      'Gdrop',
      'Gedit',
      'Ggrep',
      'Git',
      'Glcd',
      'Glgrep',
      'Gllog',
      'Gpedit',
      'Gread',
      'Gsplit',
      'Gtabedit',
      'Gvdiffsplit',
      'Gvsplit',
      'Gwq',
      'Gwrite',
    },
    event = { 'BufWritePost', 'BufReadPre' },

    keys = function()
      local function get_branch_name()
        local branch =
          vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
        return branch
      end
      -- stylua: ignore start
    return {
      { "gh", "<cmd>vert Git<cr><c-w>r", desc = "Files" },
      { "<leader>gd", "<cmd>Gvdiffsplit!<cr>", desc = "Diff" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Diff" },
      { "<leader>gpf", "<cmd>Git push --force-with-lease<cr>", desc = "Force" },
      { "<leader>gpu", "<cmd>Git push -u origin " .. get_branch_name() .. "<cr>", desc = "Upstream", },
    }
      -- stylua: ignore end
    end,
    config = function()
      require('configs.vim-fugitive')
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.git-conflict')
    end,
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
    cmd = { 'ColorizerToggle' },
  },

  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    init = function() -- Load oil on startup only when editing a directory
      vim.g.loaded_fzf_file_explorer = 1
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.api.nvim_create_autocmd('BufEnter', {
        nested = true,
        group = vim.api.nvim_create_augroup('OilInit', {}),
        callback = function(info)
          local path = info.file
          if path == '' then
            return
          end
          -- Workaround for path with trailing `..`
          if path:match('%.%.$') then
            path = vim.fs.dirname(vim.fs.dirname(path) or '')
            if not path or path == '' then
              return
            end
          end
          local stat = vim.uv.fs_stat(path)
          if stat and stat.type == 'directory' then
            vim.api.nvim_exec_autocmds('UIEnter', {})
            require('oil')
            vim.cmd.edit()
            return true
          end
        end,
      })
    end,
    config = function()
      require('configs.oil')
    end,
  },

  {
    'echasnovski/mini.nvim',
    event = { 'BufReadPost' },
    config = function()
      require('configs.mini')
    end,
  },

  {
    'barrett-ruth/live-server.nvim',
    cmd = { 'LiveServerStart', 'LiveServerStop' },
    config = function()
      require('live-server').setup()
    end,
  },

  {
    'numToStr/FTerm.nvim',
    event = 'VeryLazy',
    config = function()
      require('configs.fterm')
    end,
  },

  {
    'rodolfoksveiga/drex.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<C-N>', '<cmd>lua require("user.drex").find_element("%")<cr>', desc = 'File explorer', },
      { "<leader><C-N>", '<cmd>Drex %:h<cr>', desc = "open the parent directory" },
    },
    config = function()
      require('configs.drex')
    end,
  },

  {
    'ibhagwan/fzf-lua',
    event = 'VeryLazy',
    config = function()
      require('configs.fzf-lua.mappings')
      require('configs.fzf-lua.cmds')
      require('configs.fzf-lua.setup').setup()

      -- register fzf-lua as vim.ui.select interface
      require('fzf-lua').register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.70
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.60, row = 0.40 } }
      end)
    end,
  },
}
