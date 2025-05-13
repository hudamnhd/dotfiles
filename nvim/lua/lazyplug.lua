-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Downloading folke/lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  print("Succesfully downloaded lazy.nvim.")
end
vim.opt.runtimepath:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.notify("Error downloading lazy.nvim", vim.log.levels.ERROR, {})
end

lazy.setup("plugins", {
  defaults = { lazy = true },
  checker = { enabled = false },          -- don't auto-check for plugin updates
  change_detection = { enabled = false }, -- don't auto-check for config updates
  ui = {
    border = "rounded",
    custom_keys = {
      ["<localleader>l"] = false,
      ["<localleader>t"] = false,
    },
  },
  debug = false,
  performance = {
    rtp = {},
  },
})
