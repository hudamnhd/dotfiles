local M = {}

local function echo(chunks)
  vim.api.nvim_echo(chunks, false, {})
end

do
  local cache = {}
  ---Replace termcodes
  ---@param s string
  ---@return string
  function M.T(s)
    assert(type(s) == "string", "expected string")
    if not cache[s] then
      cache[s] = vim.api.nvim_replace_termcodes(s, true, false, true)
    end
    return cache[s]
  end
end
-- vim.fn.stdpath("config") .. "/vimtutor.txt"
-- stylua: ignore start
function M.bookmarks()
  local bookmarks = {
    { "-", "Set cwd",           [[lua require("utils.helper").set_cwd()]] },
    { "d", "Toggle diff",           [[lua require("utils.helper").toggle_diff_buff()]] },
    { "o", "Toggle overlay",    [[lua require("mini.diff").toggle_overlay()]] },
    { "u", "Toggle Undotree",   [[UndotreeToggle]] },
    { "h", "Toggle Hipatterns", [[lua require("mini.hipatterns").toggle()]] },
    { "g", "GIT",               [[vert Git]] },
    { "D", "Gvdiffsplit",       [[Gvdiffsplit!]] },
    { "p", "Git log buffer",    [[Git log --stat %!]] },
    { "P", "Git log project",   [[Git log --stat -n 100]] },
    { "v", "GV",                [[GV]] },
  }
  if type(bookmarks) ~= "table" then
    echo({ { "Invalid g:bookmarks", "ErrorMsg" } })
    return
  end

  for _, item in ipairs(bookmarks) do
    echo({
      { " [", "LineNr" },
      { item[1], "WarningMsg" },
      { "] ", "LineNr" },
      { item[2], "Function" },
    })
  end
  echo({ { ":Menu" } })

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd("redraw")
  if not ok then
    return
  end
  if
    ch == 0 or ch == 27 --[[<Esc>]]
  then
    return
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(bookmarks) do
      local s1 = item[1]
      if s1 == ch then
        vim.cmd(item[3])
        return
      end
    end
  end
end
-- stylua: ignore end

return M
