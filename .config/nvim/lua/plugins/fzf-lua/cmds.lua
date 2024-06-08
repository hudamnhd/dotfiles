local M = {}

local path = require("fzf-lua.path")
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

_G.fzf_dirs = function(opts)
  local fzf_lua = require'fzf-lua'
  opts = opts or {}
  opts.prompt = "Directories> "
  opts.winopts = { height = 0.4, width = 0.5 }
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ['default'] = function(selected)
      vim.cmd("cd " .. selected[1])
    end
  }
  fzf_lua.fzf_exec("fdfind --type d", opts)
end

-- map our provider to a user command ':Directories'
vim.cmd([[command! -nargs=* Directories lua _G.fzf_dirs()]])

-- or to a keybind, both below are (sort of) equal
vim.keymap.set('n', '<a-c>', _G.fzf_dirs)

return M
