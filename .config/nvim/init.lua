-- enable loader
vim.loader.enable()

local function safe_require(module)
  local success, errMsg = pcall(require, module)
  if not success then
    local msg = ("Error loading %s\n%s"):format(module, errMsg)
    vim.defer_fn(function()
      vim.notify(msg, vim.log.levels.ERROR)
    end, 1000)
  end
end

-- disable treesitter
-- vim.treesitter.stop()

safe_require("lazyplug")

-- Load configuration files
safe_require("mru")
safe_require("options")
safe_require("autocmd")
safe_require("keymaps")
safe_require("vscript")
safe_require("utils.buffers")

-- Load default colorscheme
vim.cmd.colorscheme("tokyonight")
