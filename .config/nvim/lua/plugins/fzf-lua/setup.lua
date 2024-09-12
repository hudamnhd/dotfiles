local M = {}
local actions = require("fzf-lua.actions")
local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
local core = require("fzf-lua.core")
local path = require("fzf-lua.path")
local config = require("fzf-lua.config")

function M.get_preview_command(items)
  local opts = fzf.config.__resume_data.opts
  local entry = path.entry_to_file(items[1], opts, opts.force_uri)
  local fullpath = entry.path or (entry.uri and entry.uri:match("^%a+://(.*)"))
  if not path.is_absolute(fullpath) then
    fullpath = path.join({ opts.cwd or opts._cwd or vim.loop.cwd(), fullpath })
  end

  if vim.fn.isdirectory(fullpath) == 1 then
    return string.format("tree -C %s | head -200", fullpath)
  else
    return string.format("bat --color=always --style=numbers,changes,header %s", fullpath)
  end
end

pcall(vim.cmd, [[hi! link FzfLuaDirPart FzfLuaDirIcon]])
require("fzf-lua").setup({
  global_resume = true,
  global_resume_query = true,
  defaults = {
    -- formatter = { "path.dirname_first", v = 2 },
    git_icons = false,
    file_icons = false,
    color_icons = false,
  },
  hls = {
    fzf = {
      match = "WarningMsg",
      info = "WarningMsg",
    },
  },

  winopts = {
    height = 0.85,
    width = 0.85,
    row = 0.35,
    col = 0.50,
    border = "none",
    preview = {
      default = "bat",
      border = "noborder", -- border|noborder, applies only to
      wrap = "nowrap", -- wrap|nowrap
      hidden = "nohidden", -- hidden|nohidden
      vertical = "up:65%", -- up|down:size
      horizontal = "right:60%", -- right|left:size
      layout = "flex", -- horizontal|vertical|flex
      flip_columns = 200, -- #cols to switch to horizontal on flex
      delay = 100, -- delay(ms) displaying the preview
    },
  },

  keymap = {
    builtin = {
      ["<F1>"] = "toggle-help",
      ["<C-a>"] = "toggle-fullscreen",
      ["<C-o>"] = "toggle-preview",
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    },
    fzf = {
      ["alt-a"] = "toggle-all",
      ["ctrl-o"] = "toggle-preview",
      ["ctrl-d"] = "preview-page-down",
      ["ctrl-u"] = "preview-page-up",
    },
  },

  fzf_opts = {
    ["--prompt"] = "   ",
    ["--keep-right"] = "",
    ["--padding"] = "1,3",
    ["--no-scrollbar"] = "",
  },

  fzf_colors = true,

  files = {
    prompt = "Files  ",
    fd_opts = [[--color=never --type f]],
    fzf_opts = {
      ["--ansi"] = true,
    },
    previewer = false,
    preview = {
      type = "cmd",
      fn = function(items)
        return M.get_preview_command(items)
      end,
    },
    actions = {
      ["ctrl-space"] = require("fzf-lua").actions.arg_add,
      ["ctrl-y"] = function(selected, opts)
        local entry = path.entry_to_file(selected[1], opts, opts.force_uri)
        if entry.path == "<none>" then
          return
        end
        local path = entry.path
        vim.api.nvim_feedkeys("i", "n", true)
        vim.api.nvim_put({ path }, "c", true, true)
        local switch = vim.api.nvim_replace_termcodes("<Right>", true, false, true)
        vim.api.nvim_feedkeys(switch, "n", false)
      end,
      ["ctrl-l"] = function(selected, opts)
        local entry = path.entry_to_file(selected[1], opts, opts.force_uri)
        if entry.path == "<none>" then
          return
        end
        local _path = entry.path
        local path = vim.fn.fnamemodify(_path, ":p:h")
        local cmd = string.format(":e %s", path .. "/" .. "<CR>")
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, true, true), "n", true)
      end,
    },
  },
  oldfiles = {
    prompt = "History❯ ",
    cwd_only = true,
    stat_file = true,
    include_current_session = true, -- include bufs from current session
  },
  git = {
    files = { prompt = "Git Files  " },
    status = { prompt = "Git Status  " },
    bcommits = {
      prompt = "Git Logs  ",
      actions = {
        ["alt-d"] = function(...)
          fzf.actions.git_buf_vsplit(...)
          vim.cmd("windo diffthis")
          local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
          vim.api.nvim_feedkeys(switch, "t", false)
        end,
      },
    },
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
  },
  highlights = {
    actions = {
      ["default"] = function(entry)
        local hl_group = entry[1]
        vim.fn.setreg("+", hl_group)
        vim.notify("Copied " .. hl_group .. " to the clipboard!", vim.log.levels.INFO)
      end,
    },
  },
  buffers = {
    formatter = { "path.dirname_first", v = 2 },
    actions = {
      ["ctrl-l"] = require("fzf-lua").actions.file_edit,
      ["ctrl-space"] = require("fzf-lua").actions.file_edit,
    },
  },
})
