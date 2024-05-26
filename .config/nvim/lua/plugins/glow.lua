return
{
  "ellisonleao/glow.nvim",
  ft = "markdown",
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

   local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
   local MarkdownPreview = vim.api.nvim_create_augroup("MarkdownPreview", {})

   autocmd("BufWinEnter", {
     group = MarkdownPreview,
     pattern = "*",
     callback = function()
       -- Check if the buffer file type is "fugitive"
       if vim.bo.ft ~= "markdown" then
         return
       end

       local bufnr = vim.api.nvim_get_current_buf()
       local opts = { buffer = bufnr, remap = false }

       -- stylua: ignore start
       vim.keymap.set("n", "a", function() vim.cmd("Glow") end, opts)
       -- stylua: ignore end
     end,
   })
  end,
}
