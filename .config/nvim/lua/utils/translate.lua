local M = {}
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
  vim.keymap.set("n", "q", vim.cmd.q, { buffer = buf })

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
  local text = require("utils.search-replace").get_visual_selection(true)
  enter_translate_cmd(text)
end

return M
