return {
    module = 'mini.files',
    opts = {
      options = { permanent_delete = false },
    },
    -- See :help MiniFiles
    config = function()
      local MiniFiles = require('mini.files')

      vim.keymap.set('n', '<Leader>e', function()
        local file = vim.api.nvim_buf_get_name(0)
        if vim.fn.filereadable(file) == 1 then
          MiniFiles.open(file)
        else
          MiniFiles.open()
        end
      end, { desc = 'Explorer' })

      -- # Create mappings to modify target window via split ~
      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local cur_target = MiniFiles.get_explorer_state().target_window
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target)

          -- This intentionally doesn't act on file under cursor in favor of
          -- explicit "go in" action (`l` / `L`). To immediately open file,
          -- add appropriate `MiniFiles.go_in()` call instead of this comment.
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      -- Set focused directory as current working directory
      local set_cwd = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then return vim.notify('Cursor is not on valid entry') end
        vim.fn.chdir(vim.fs.dirname(path))
      end

      -- Yank in register full path of entry under cursor
      local yank_path = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then return vim.notify('Cursor is not on valid entry') end
        vim.fn.setreg(vim.v.register, path)
      end

      -- Open path with system default handler (useful for non-text files)
      local ui_open = function() vim.ui.open(MiniFiles.get_fs_entry().path) end

      local set_mark = function(id, path, desc) MiniFiles.set_bookmark(id, path, { desc = desc }) end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local b = args.data.buf_id
          -- Tweak keys to your liking
          map_split(b, 'gs', 'belowright horizontal')
          map_split(b, 'gv', 'belowright vertical')
          map_split(b, 'gt', 'tab')

          set_mark('c', vim.fn.stdpath('config'), 'Config') -- path
          set_mark('w', vim.fn.getcwd, 'Working directory') -- callable
          set_mark('~', '~', 'Home directory')

          vim.keymap.set('n', 'g~', set_cwd, { buffer = b, desc = 'Set cwd' })
          vim.keymap.set('n', 'gX', ui_open, { buffer = b, desc = 'OS open' })
          vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
        end,
      })
    end,
  }
