return {
    {
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
      },
      config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)
        vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
      end,
    }
}

