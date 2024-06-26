return {
  "nvim-telescope/telescope.nvim",
  keys = { "sn", "<c-n>" },
  dependencies = { "nvim-telescope/telescope-file-browser.nvim" },
  config = function()
    local fb_actions = require("telescope._extensions.file_browser.actions")
    local actions = require("telescope.actions")
    local config = require("telescope.config")

    local previewers = require("telescope.previewers")

    local new_maker = function(filepath, bufnr, opts)
      opts = opts or {}

      filepath = vim.fn.expand(filepath)
      vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then
          return
        end
        if stat.size > 100000 then
          return
        else
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
      end)
    end

    require("telescope").setup({
      defaults = {
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        scroll_strategy = "limit",
        layout_strategy = "flex",
        results_title = false,
        dynamic_preview_title = true,
        -- path_display = { truncate = 0 },
        -- https://github.com/nvim-telescope/telescope.nvim/pull/3010
        path_display = { filename_first = { reverse_directories = false } },
        buffer_previewer_maker = new_maker,
        layout_config = {
          width = 0.95,
          height = 0.85,
          prompt_position = "top",
          horizontal = {
            -- width_padding = 0.1,
            -- height_padding = 0.1,
            width = 0.9,
            preview_cutoff = 60,
            preview_width = function(_, cols, _)
              if cols > 200 then
                return math.floor(cols * 0.7)
              else
                return math.floor(cols * 0.6)
              end
            end,
          },
          vertical = {
            -- width_padding = 0.05,
            -- height_padding = 1,
            width = 0.75,
            height = 0.85,
            preview_height = 0.4,
            mirror = true,
          },
          flex = {
            -- change to horizontal after 120 cols
            flip_columns = 120,
          },
        },
        mappings = {

          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_default,
            ["<C-l>"] = actions.select_default,
          },

          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["l"] = actions.select_default,
            -- TODO: This would be weird if we switch the ordering.
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-c>"] = actions.close,
            ["?"] = actions.which_key,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--column",
          "--line-number",
          "--with-filename",
          "--no-heading",
          "--smart-case",
          -- "--hidden",
        },
      },
      pickers = {
        find_files = {
          disable_devicons = true,
        },
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
      },
      extensions = {
        file_browser = {
          -- path = vim.loop.cwd(),

          hide_parent_dir = true,
          prompt_path = true,
          respect_gitignore = vim.fn.executable("fdfind") == 1,
          no_ignore = true,
          git_status = false,
          disable_devicons = true,
          mappings = {
            ["i"] = {
              ["<A-c>"] = fb_actions.create,
              ["<S-CR>"] = fb_actions.create_from_prompt,
              ["<A-r>"] = fb_actions.rename,
              ["<A-m>"] = fb_actions.move,
              ["<A-y>"] = fb_actions.copy,
              ["<A-d>"] = fb_actions.remove,
              ["<C-o>"] = fb_actions.open,
              ["<c-h>"] = fb_actions.toggle_hidden,
              ["<C-g>"] = fb_actions.goto_parent_dir,
              ["<C-e>"] = fb_actions.goto_home_dir,
              ["<C-w>"] = fb_actions.goto_cwd,
              ["<C-t>"] = fb_actions.change_cwd,
              ["<C-z>"] = fb_actions.toggle_browser,
              ["<C-s>"] = fb_actions.toggle_all,
              ["<C-a>"] = fb_actions.backspace,
              ["<bs>"] = {
                function()
                  -- exit to normal mode
                  vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<bs>", true, false, true),
                    "n",
                    true
                  )
                end,
                type = "command",
              },
              ["<c-f>"] = {
                function()
                  -- exit to normal mode
                  vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Right>", true, false, true),
                    "n",
                    true
                  )
                end,
                type = "command",
              },
              -- ["<bs>"] = fb_actions.nop,
            },
            ["n"] = {
              ["c"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["y"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["o"] = fb_actions.open,
              ["g"] = fb_actions.goto_parent_dir,
              ["h"] = fb_actions.goto_parent_dir,
              ["e"] = fb_actions.goto_home_dir,
              ["w"] = fb_actions.goto_cwd,
              ["t"] = fb_actions.change_cwd,
              ["f"] = fb_actions.toggle_browser,
              ["<space>h"] = fb_actions.toggle_hidden,
              ["s"] = fb_actions.toggle_all,
            },
          },
        },
      },
    })

    require("telescope").load_extension("file_browser")

    vim.keymap.set("n", "sn", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
    vim.keymap.set("n", "<c-n>", ":Telescope file_browser<CR>")
    vim.keymap.set("n", "S", ":Telescope builtin<CR>")
  end,
}
