return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  opts = {
    columns = {
      "size",
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    experimental_watch_for_changes = true,
    keymaps = {
      ["h"] = { "actions.parent", mode = "n", desc = "parent" },
      ["l"] = { "actions.select", mode = "n", desc = "select" },
      ["<C-p>"] = { "actions.preview", mode = "n" },
      ["<F5>"] = { "actions.refresh", mode = "n" },
      ["<CR>"] = { "actions.select", mode = "n" },
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.tcd", mode = "n" },
      ["~"] = { "<cmd>edit $HOME<CR>", mode = "n" },
      ["q"] = { "actions.close", mode = "n" },
      ["?"] = { "actions.show_help", mode = "n" },
      ["gh"] = { "actions.toggle_hidden", mode = "n" },
      ["gz"] = { "actions.change_sort", mode = "n" },
      ["gx"] = { "actions.open_external", mode = "n" },
      ["T"] = { "actions.toggle_trash", mode = "n" },
      ["gd"] = {
        desc = "Toggle detail view",
        callback = function()
          local oil = require("oil")
          local config = require("oil.config")
          if #config.columns == 1 then
            oil.set_columns({ "size", "permissions", "mtime", "icon" })
          else
            oil.set_columns({ "size" })
          end
        end,
      },
      ["Y"] = {
        -- source: https://www.reddit.com/r/neovim/comments/1czp9zr/comment/l5hv900/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        desc = "Copy filepath to system clipboard",
        callback = function()
          require("oil.actions").copy_entry_path.callback()
          local copied = vim.fn.getreg(vim.v.register)
          vim.fn.setreg("+", copied)
          vim.notify("Copied to system clipboard:\n" .. copied, vim.log.levels.INFO, {})
        end,
      },
    },
    use_default_keymaps = false,
    view_options = {
      is_always_hidden = function(name, bufnr)
        return name == ".."
      end,
    },
  },
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(opts)
    vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
  end,
}
