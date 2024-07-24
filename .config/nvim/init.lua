local function safeRequire(module)
  local success, errMsg = pcall(require, module)
  if not success then
    local msg = ("Error loading %s\n%s"):format(module, errMsg)
    vim.defer_fn(function()
      vim.notify(msg, vim.log.levels.ERROR)
    end, 1000)
  end
end

vim.g.Eunuch_find_executable = 'fd'

-- disable treesitter
-- vim.treesitter.stop()

-- Load configuration files
safeRequire("mru")
safeRequire("lazyplug")
safeRequire("options")
safeRequire("utils.vscript")
safeRequire("autocmd")
-- safeRequire("keymaps")

pcall(vim.cmd, [[colorscheme default]])
pcall(vim.cmd, [[hi! link LineNr Comment]])
-- pcall(vim.cmd, [[hi! link DirvishSuffix Comment]])

-- enable loader
vim.loader.enable()

