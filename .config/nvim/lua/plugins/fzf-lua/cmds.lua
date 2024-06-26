local M = {}

local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
local path = require("fzf-lua.path")
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
    fzf.fzf_exec(files, {
      actions = {
        ["default"] = require("fzf-lua").actions.file_edit,
      },
      fzf_opts = {
        ["--multi"] = "",
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
