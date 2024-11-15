local M = {}

local config = require("search-replace.config")
local util = require("search-replace.util")

local within = function(pattern)
  local shift = 0

  if string.len(pattern) == 0 then
    shift = 2
  else
    shift = 1
  end

  local left_keypresses = string.rep(
    "\\<Left>",
    string.len(config.options["default_replace_single_buffer_options"]) + shift
  )

  -- local lastMode = vim.fn.mode()
  -- print("DEBUGPRINT[1]: local-replace.lua:38: lastMode=" .. vim.inspect(lastMode))
  --
  -- if lastMode == "n" then
  --   vim.cmd("normal! gv")
  -- end
  --
  vim.cmd(
    ':call feedkeys(":s/'
      .. util.double_escape(pattern)
      .. "/"
      .. util.double_escape(pattern)
      .. "/"
      .. config.options["default_replace_single_buffer_options"]
      .. left_keypresses
      .. '")'
  )
end

M.within = function()
  within("")
end

M.within_cword = function()
  within(vim.fn.expand("<cword>"))
end

M.within_cWORD = function()
  within(vim.fn.expand("<cWORD>"))
end

M.within_cexpr = function()
  within(vim.fn.expand("<cexpr>"))
end

M.within_cfile = function()
  within(vim.fn.expand("<cfile>"))
end

return M
