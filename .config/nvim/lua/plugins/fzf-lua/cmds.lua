local M = {}

local fzf_lua = require("fzf-lua")
local api, fn, uv = vim.api, vim.fn, vim.loop

---Most recently used files
function _G.mru()
  local current
  if api.nvim_buf_get_option(0, "buftype") == "" then
    current = uv.fs_realpath(api.nvim_buf_get_name(0))
  end

  local files = {}
  for _, file in ipairs(require("utils.mru").get()) do
    if file ~= current then
      files[#files + 1] = fn.fnamemodify(file, ":~")
    end
  end

  if #files > 0 then
    fzf_lua.fzf_exec(files, {
      actions = {
        ["default"] = require("fzf-lua").actions.file_edit,
      },
      prompt = "MRU> ",
      winopts = { height = 0.4, width = 0.5 },
    })
  else
    print("No recently used files", "WarningMsg")
  end
end

vim.cmd([[command! -nargs=* MRU lua _G.mru()]])

return M
