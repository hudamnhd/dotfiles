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
safeRequire("options")
safeRequire("autocmd")
safeRequire("lazyplug")
safeRequire("keymaps")
safeRequire("utils.mru")
safeRequire("utils.cmd")
safeRequire("utils.m")
safeRequire("utils.global")

pcall(vim.cmd, [[colorscheme catppuccin-mocha]])

vim.api.nvim_set_hl(0, "TabLineSel",                    { fg = "#343D46", bg = "#D8DEE9" })
vim.api.nvim_set_hl(0, "TabLineDividerSel",             { fg = "#343D46", bg = "#D8DEE9" })
vim.api.nvim_set_hl(0, "TabLineIndexSel",               { fg = "#343D46", bg = "#D8DEE9" })
vim.api.nvim_set_hl(0, "TabLine",                       { fg = "#eeeeee", bg = "#3d4751" })
vim.api.nvim_set_hl(0, "TabLineDir",                    { fg = "#D8DEE9", bg = "#343D46" })
vim.api.nvim_set_hl(0, "TabLineDivider",                { fg = "#eeeeee", bg = "#3d4751" })
vim.api.nvim_set_hl(0, "TabLineDividerVisible",         { fg = "#eeeeee", bg = "#3d4751" })
vim.api.nvim_set_hl(0, "TabLineFill",                   { fg = "#D8DEE9", bg = "#343D46" })
vim.api.nvim_set_hl(0, "TabLineIndex",                  { fg = "#eeeeee", bg = "#3d4751" })
vim.api.nvim_set_hl(0, "TabLineIndexVisible",           { fg = "#343D46", bg = "#D8DEE9" })
vim.api.nvim_set_hl(0, "TabLineScrollIndicator",        { fg = "#eeeeee", bg = "#3d4751" })
vim.api.nvim_set_hl(0, "TabLineVisible",                { fg = "#343D46", bg = "#D8DEE9" })
vim.api.nvim_set_hl(0, "TabLineModified",               { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineModifiedVisible",        { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineIndexModified",          { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineIndexModifiedSel",       { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineIndexModifiedVisible",   { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineDividerModified",        { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineDividerModifiedSel",     { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineDividerModifiedVisible", { fg = "#343D46", bg = "#F9AE58" })
vim.api.nvim_set_hl(0, "TabLineModifiedSel",            { fg = "#343D46", bg = "#F9AE58" })

-- set colorscheme default
