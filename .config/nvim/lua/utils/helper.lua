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

local fzf_lua = require("fzf-lua")
function M.asynctasks()
  local rows = vim.fn["asynctasks#source"](vim.go.columns * 48 / 100)
  fzf_lua.fzf_exec(function(cb)
    for _, e in ipairs(rows) do
      local color = fzf_lua.utils.ansi_codes
      local line = color.green(e[1]) .. " " .. color.cyan(e[2]) .. ": " .. color.yellow(e[3])
      cb(line)
    end
    cb()
  end, {
    actions = {
      ["default"] = function(selected)
        print(vim.inspect(selected))
        local str = fzf_lua.utils.strsplit(selected[1], " ")
        local command = "AsyncTask " .. vim.fn.fnameescape(str[1])
        vim.defer_fn(function()
          vim.api.nvim_exec(command, false)
        end, 500) -- 5000 milliseconds = 5 seconds
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--nth"] = "1",
    },
    winopts = {
      height = 0.6,
      width = 0.6,
    },
  })
end

local diff_enabled = false

function M.toggle_diff_buff()
  if diff_enabled then
    vim.cmd("windo diffoff")
  else
    vim.cmd("windo diffthis")
  end
  diff_enabled = not diff_enabled
end

function M.duplicate_bak_file()
  vim.cmd([[
    clear | silent execute "!cp '%:p' '%:p:h/%:t:r.%:e.bak'"
    redraw | echo "Copied " .. expand('%:t') .. ' to ' .. expand('%:t:r') .. '.' .. expand('%:e') .. '.bak'
  ]])
end

---- NOTE utils
local fast_event_aware_notify = function(msg, level, opts)
  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(msg, level, opts)
    end)
  else
    vim.notify(msg, level, opts)
  end
end

function M.info(msg)
  fast_event_aware_notify(msg, vim.log.levels.INFO, {})
end

function M.warn(msg)
  fast_event_aware_notify(msg, vim.log.levels.WARN, {})
end

function M.err(msg)
  fast_event_aware_notify(msg, vim.log.levels.ERROR, {})
end

function M.shell_error()
  return vim.v.shell_error ~= 0
end

function M.git_root(cwd, noerr)
  local cmd = { "git", "rev-parse", "--show-toplevel" }
  if cwd then
    table.insert(cmd, 2, "-C")
    table.insert(cmd, 3, vim.fn.expand(cwd))
  end
  local output = vim.fn.systemlist(cmd)
  if M.shell_error() then
    if not noerr then
      M.info(unpack(output))
    end
    return nil
  end
  return output[1]
end

function M.set_cwd(pwd)
  if not pwd then
    local parent = vim.fn.expand("%:h")
    pwd = M.git_root(parent, true) or parent
  end
  if vim.loop.fs_stat(pwd) then
    vim.cmd("cd " .. pwd)
    M.info(("pwd set to %s"):format(vim.fn.shellescape(pwd)))
  else
    M.warn(("Unable to set pwd to %s, directory is not accessible"):format(vim.fn.shellescape(pwd)))
  end
end

function M.get_visual_selection(nl_literal)
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = #lines
  if n <= 0 then
    return ""
  end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, nl_literal and "\\n" or "\n")
end

-- expand or minimize current buffer in a more natural direction (tmux-like)
-- ':resize <+-n>' or ':vert resize <+-n>' increases or decreasese current
-- window horizontally or vertically. When mapped to '<leader><arrow>' this
-- can get confusing as left might actually be right, etc
-- the below can be mapped to arrows and will work similar to the tmux binds
-- map to: "<cmd>lua require'utils'.resize(false, -5)<CR>"
function M.resize(vertical, margin)
  local cur_win = vim.api.nvim_get_current_win()
  -- go (possibly) right
  vim.cmd(string.format("wincmd %s", vertical and "l" or "j"))
  local new_win = vim.api.nvim_get_current_win()

  -- determine direction cond on increase and existing right-hand buffer
  local not_last = not (cur_win == new_win)
  local sign = margin > 0
  -- go to previous window if required otherwise flip sign
  if not_last == true then
    vim.cmd([[wincmd p]])
  else
    sign = not sign
  end

  local sign_str = sign and "+" or "-"
  local dir = vertical and "vertical " or ""
  local cmd = dir .. "resize " .. sign_str .. math.abs(margin) .. "<CR>"
  vim.cmd(cmd)
end

-- https://github.com/soimort/translate-shell/wiki/Languages

-- stylua: ignore start
local languages = {
  "af", "am", "ar", "az", "ba", "be", "bg", "bn", "bs", "ca", "co", "cs", "cy", "da", "de", "el",
  "en", "eo", "es", "et", "eu", "fa", "fi", "fj", "fr", "fy", "ga", "gd", "gl", "gu", "ha", "he",
  "hi", "hr", "ht", "hu", "hy", "id", "ig", "is", "it", "ja", "jv", "ka", "kk", "km", "kn", "ko",
  "ku", "ky", "la", "lb", "lo", "lt", "lv", "mg", "mi", "mk", "ml", "mn", "mr", "ms", "mt", "my",
  "ne", "nl", "no", "ny", "or", "pa", "pl", "ps", "pt", "ro", "ru", "rw", "sd", "si", "sk", "sl",
  "sm", "sn", "so", "sq", "st", "su", "sv", "sw", "ta", "te", "tg", "th", "tk", "tl", "to", "tr",
  "tt", "ty", "ug", "uk", "ur", "uz", "vi", "xh", "yi", "yo", "zu",
}
-- stylua: ignore end

vim.api.nvim_create_user_command("Translate", function(opts)
  if #opts.fargs < 3 then
    vim.api.nvim_echo({
      {
        "Too few arguments ("
          .. #opts.fargs
          .. "): 'translate <source language> <target language> <text>'",
        "WarningMsg",
      },
    }, false, {})
    return
  end

  if vim.fn.executable("trans") == 0 then
    vim.api.nvim_echo({
      { "'trans' was not found in path, install it in order to use this command!", "warningmsg" },
    }, false, {})
    return
  end

  local source, target = unpack(opts.fargs)
  local text = string.sub(opts.args, #(source .. " " .. target .. " ") + 1)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("syntax", "gitcommit", { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "# press 'q' to exit" })
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("read !trans -no-ansi -s " .. source .. " -t " .. target .. ' "' .. text .. '"')
  end)
  -- easy window closing
  vim.api.nvim_create_autocmd("WinLeave", {
    command = "q",
    buffer = buf,
  })
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf })

  -- check for the longest line (as `max_width`)
  local max_width = 0
  local buflines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for _, line in ipairs(buflines) do
    if #line > max_width then
      max_width = #line
    end
  end
  max_width = max_width + 2 -- add some padding

  local total_width = vim.opt.columns:get()
  local width = max_width > total_width and total_width or max_width

  local total_height = vim.opt.lines:get()
  local height = #buflines > total_height and total_height or #buflines

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (total_width - width) / 2,
    row = 0,
    style = "minimal",
    border = "single",
    noautocmd = false,
  })
end, {
  nargs = "*",
  complete = function(lead, line, _)
    -- we only want completion for the first two (language) arguments
    local arg = #vim.split(line, " ", {}) - 1
    if arg < 3 then
      return vim.tbl_filter(function(e)
        -- check for languages that start with the typed chars
        return e:sub(1, #lead) == lead
      end, languages)
    end

    return {}
  end,
  desc = "translate",
})

local function enter_translate_cmd(text)
  local go_left = vim.api.nvim_replace_termcodes("<left>", true, false, true)
  vim.api.nvim_feedkeys(
    ":Translate  " .. text .. string.rep(go_left, vim.str_utfindex(text) + 1),
    "n",
    true
  )
end

function M.translate_nm()
  local word = vim.fn.expand("<cword>")
  enter_translate_cmd(word)
end

function M.translate_vm()
  local text = M.get_visual_selection()
  enter_translate_cmd(text)
end

return M
