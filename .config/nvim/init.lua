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
-- vim.treesitter.stop()

-- Load configuration files
-- safeRequire("keymaps")
safeRequire("lazyplug")
safeRequire("options")
safeRequire("mru")
safeRequire("utils.vscript")
safeRequire("autocmd")

pcall(vim.cmd, [[colorscheme catppuccin-mocha]])
pcall(vim.cmd, [[hi! link LineNr Comment]])

-- enable loader
vim.loader.enable()

vim.cmd([[
  hi MiniJump2dSpotUnique cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#eeeeee
]])
