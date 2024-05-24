local M = {}

local fzf_lua = require("fzf-lua")
local m = require("utils.m")
local api, fn, uv = vim.api, vim.fn, vim.loop

function M.git_bcommits(opts)
  local function diffthis(action)
    return function(...)
      local curwin = vim.api.nvim_get_current_win()
      action(...)
      vim.cmd("windo diffthis")
      vim.api.nvim_set_current_win(curwin)
    end
  end

  opts.actions = {
    ["ctrl-v"] = diffthis(fzf_lua.actions.git_buf_vsplit),
  }
  return fzf_lua.git_bcommits(opts)
end

function M.git_status_tmuxZ(opts)
  if fzf_lua.config.globals.fzf_bin == "fzf-tmux" then
    opts.fzf_tmux_opts = { ["-p"] = "100%,100%" }
    return fzf_lua.git_status(opts)
  end

  local function tmuxZ()
    vim.cmd("!tmux resize-pane -Z")
  end

  opts = opts or {}
  opts.fn_pre_win = function(_)
    if not opts.__want_resume then
      -- new fzf window, set tmux Z
      -- add small delay or fzf
      -- win gets wrong dimensions
      tmuxZ()
      vim.cmd("sleep! 20m")
    end
    opts.__want_resume = nil
  end
  opts.fn_post_fzf = function(_, s)
    opts.__want_resume = s and (s[1] == "left" or s[1] == "right")
    if not opts.__want_resume then
      -- resume asked do not resize
      -- signals fn_pre to do the same
      tmuxZ()
    end
  end
  fzf_lua.git_status(opts)
end


 function M.diagnostics_document(opts)
   opts = opts or {}
   opts.diag_source = #vim.lsp.get_active_clients({
     bufnr = vim.api.nvim_get_current_buf(),
   }) > 1 and true or false
   opts.icon_padding = opts.diag_source and "" or " "
   fzf_lua.diagnostics_document(opts)
 end

 function M.diagnostics_workspace(opts)
   opts = opts or {}
   opts.diag_source = #vim.lsp.get_active_clients() > 1 and true or false
   opts.icon_padding = opts.diag_source and "" or " "
   fzf_lua.diagnostics_workspace(opts)
 end

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
    m.echo("No recently used files", "WarningMsg")
  end
end

vim.cmd([[command! -nargs=* MRU lua _G.mru()]])

return M
