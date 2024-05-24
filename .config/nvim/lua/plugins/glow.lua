return
{
  "ellisonleao/glow.nvim",
  cmd = "Glow",
  config = function()
    require("glow").setup({
      -- glow_path = "/home/hudamnhd/.local/bin/glow",
      -- install_path = "/home/hudamnhd/.local/bin/glow", -- default path for installing glow binary
      -- style = "dark|light", -- filled automatically with your current editor background, you can override using glow json style
      -- pager = false,
      border = "shadow", -- floating window border config
      width = 800,
      height = 100,
      width_ratio = 0.9, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      height_ratio = 0.9,
    })
  end,
  vim.keymap.set("n", "zg", "<CMD>Glow<CR>", { silent = true }),
}
