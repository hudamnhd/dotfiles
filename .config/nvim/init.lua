local function safeRequire(module)
  local success, errMsg = pcall(require, module)
  if not success then
    local msg = ("Error loading %s\n%s"):format(module, errMsg)
    vim.defer_fn(function()
      vim.notify(msg, vim.log.levels.ERROR)
    end, 1000)
  end
end

-- disable treesitter
vim.treesitter.stop()

-- enable loader
vim.loader.enable()

-- Load configuration files
safeRequire("mru")
safeRequire("options")
safeRequire("autocmd")
safeRequire("keymaps")
safeRequire("lazyplug")
safeRequire("vscript")
safeRequire("utils.buffers")

-- Load default colorscheme
pcall(vim.cmd, [[colorscheme default]])
pcall(vim.cmd, [[hi! link LineNr Comment]])
