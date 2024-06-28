vim.g.loaded_fzf_file_explorer = 1
return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
      experimental_watch_for_changes = true,
      keymaps = {
        ["`"] = "actions.tcd",
        ["~"] = "<cmd>edit $HOME<CR>",
        ["<leader>t"] = "actions.open_terminal",
        ["gd"] = {
          desc = "Toggle detail view",
          callback = function()
            local oil = require("oil")
            local config = require("oil.config")
            if #config.columns == 1 then
              oil.set_columns({ "icon", "permissions", "size", "mtime" })
            else
              oil.set_columns({ "icon" })
            end
          end,
        },
        ["gh"] = {
          desc = "Back cwd",
          callback = function()
            local oil = require("oil")
            oil.open(vim.fn.getcwd())
          end,
        },
        ["q"] = "actions.close",
        ["g?"] = "actions.show_help",
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["h"] = "actions.parent",
        ["h"] =  { "actions.parent", mode = "n", desc = "parent" },
        ["l"] =  { "actions.select", mode = "n", desc = "select" },
        -- ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.toggle_hidden",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<F5>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = false,
      view_options = {
        is_always_hidden = function(name, bufnr)
          return name == ".."
        end,
      },

      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
    },
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)
      vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
      vim.keymap.set("n", "_", function()
        oil.open(vim.fn.getcwd())
      end, { desc = "Open cwd" })
    end,
  },
}
