-- vim.keymap.set("n", "gw", "<cmd>cclose | Grep <cword><CR>", { desc = "Grep for word" })

return {
  {
    "stefandtw/quickfix-reflector.vim",
    ft = "qf",
  },
  {
    "gabrielpoca/replacer.nvim",
    ft = "qf",
    opts = { rename_files = false },
    config = function()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>h",
        ':lua require("replacer").run()<cr>',
        { silent = true }
      )
    end,
  },
  {
    "thinca/vim-qfreplace",
    ft = "qf",
    config = function()
      vim.keymap.set("n", "<A-r>", "<CMD>Qfreplace<CR>")
    end,
  },
  {
    "stevearc/qf_helper.nvim",
    ft = "qf",
    -- cmd = { "QNext", "QPrev", "QFToggle", "QFOpen", "LLToggle" },
    keys = {
      { "<C-N>", "<cmd>QNext<CR>", desc = "[N]ext in quickfix" },
      { "<C-P>", "<cmd>QPrev<CR>", desc = "[P]rev in quickfix" },
      { "<C-q>", "<cmd>QFToggle!<CR>", desc = "Toggle [Q]uickfix" },
    },
    config = function()
      require("qf_helper").setup({
        prefer_loclist = false,
        quickfix = {
          default_bindings = false, -- Set up recommended bindings in qf window
        },
      })
    end,
  },
}
