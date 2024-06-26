local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup("RestoreCursor", function(g)
  aucmd("BufReadPost", {
    group = g,
    pattern = "*",
    command = [[silent! normal! g`"zv']],
  })
end)

augroup("highlightYank", function(g)
  aucmd("TextYankPost", {
    group = g,
    pattern = "*",
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
  })
end)

augroup("NewlineNoAutoComments", function(g)
  aucmd("BufEnter", {
    group = g,
    pattern = "*",
    command = "setlocal formatoptions-=o",
  })
end)

-- Display help|man in vertical splits and map 'q' to quit
augroup("Help", function(g)
  local function open_vert()
    -- do nothing for floating windows or if this is
    -- the fzf-lua minimized help window (height=1)
    local cfg = vim.api.nvim_win_get_config(0)
    if
      cfg and (cfg.external or cfg.relative and #cfg.relative > 0)
      or vim.api.nvim_win_get_height(0) == 1
    then
      return
    end
    -- do not run if Diffview is open
    if vim.g.diffview_nvim_loaded and require("diffview.lib").get_current_view() then
      return
    end
    local width = math.floor(vim.o.columns * 0.75)
    vim.cmd("wincmd L")
    vim.cmd("vertical resize " .. width)
    vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = true })
  end

  aucmd("FileType", {
    group = g,
    pattern = "help,man",
    callback = open_vert,
  })

  -- we also need this auto command or help
  -- still opens in a split on subsequent opens
  aucmd("BufEnter", {
    group = g,
    pattern = "*.txt",
    callback = function()
      if vim.bo.buftype == "help" then
        open_vert()
      end
    end,
  })

  aucmd("BufHidden", {
    group = g,
    pattern = "man://*",
    callback = function()
      if vim.bo.filetype == "man" then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end, 0)
      end
    end,
  })
end)

-- https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
augroup("DoNotAutoScroll", function(g)
  local function is_float(winnr)
    local wincfg = vim.api.nvim_win_get_config(winnr)
    if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then
      return true
    end
    return false
  end

  aucmd("BufLeave", {
    group = g,
    pattern = "*",
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      -- at this stage, current buffer is the buffer we leave
      -- but the current window already changed, verify neither
      -- source nor destination are floating windows
      local from_buf = vim.api.nvim_get_current_buf()
      local from_win = vim.fn.bufwinid(from_buf)
      local to_win = vim.api.nvim_get_current_win()
      if not is_float(to_win) and not is_float(from_win) then
        vim.b.__VIEWSTATE = vim.fn.winsaveview()
      end
    end,
  })

  aucmd("BufEnter", {
    group = g,
    pattern = "*",
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      if vim.b.__VIEWSTATE then
        local to_win = vim.api.nvim_get_current_win()
        if not is_float(to_win) then
          vim.fn.winrestview(vim.b.__VIEWSTATE)
        end
        vim.b.__VIEWSTATE = nil
      end
    end,
  })
end)

augroup("GQFormatter", function(g)
  aucmd({ "FileType", "LspAttach" }, {
    group = g,
    pattern = "*",
    callback = function(e)
      -- priortize LSP formatting as `gq`
      if e.file:match("^fugitive:") then
        return
      end
      local lsp_has_formatting = false
      local lsp_clients = vim.lsp.get_active_clients()
      local lsp_keymap_set = function(m, c)
        vim.keymap.set(m, "gq", function()
          vim.lsp.buf.format({ async = true, bufnr = e.buf })
        end, {
          silent = true,
          buffer = e.buf,
          desc = string.format("format document [LSP:%s]", c.name),
        })
      end
      vim.tbl_map(function(c)
        if c.supports_method("textDocument/rangeFormatting", { bufnr = e.buf }) then
          lsp_keymap_set("x", c)
          lsp_has_formatting = true
        end
        if c.supports_method("textDocument/formatting", { bufnr = e.buf }) then
          lsp_keymap_set("n", c)
          lsp_has_formatting = true
        end
      end, lsp_clients)
      -- check conform.nvim for formatters:
      --   (1) if we have no LSP formatter map as `gq`
      --   (2) if LSP formatter exists, map as `gQ`
      local ok, conform = pcall(require, "conform")
      local formatters = ok and conform.list_formatters(e.buf) or {}
      if #formatters > 0 then
        vim.keymap.set("n", lsp_has_formatting and "gQ" or "gq", function()
          require("conform").format({ async = true, buffer = e.buf, lsp_fallback = false })
        end, {
          silent = true,
          buffer = e.buf,
          desc = string.format("format document [%s]", formatters[1].name),
        })
      end
    end,
  })
end)

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

vim.keymap.set("n", "st", function()
  local word = vim.fn.expand("<cword>")
  enter_translate_cmd(word)
end, { desc = "translate word" })

vim.keymap.set("x", "st", function()
  -- leave to normal mode via 'esc' in order to retrieve "last" selection
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
  local _, row_start, col_start, _ = unpack(vim.fn.getpos("'<"))
  local _, row_end, col_end, _ = unpack(vim.fn.getpos("'>"))

  -- prevent "Column index is too high" error for linewise visual mode
  if col_end > 2000000000 then
    col_end = col_end - 1
  end
  if col_start > 2000000000 then
    col_start = col_start - 1
  end

  local text
  if row_start < row_end or (row_start == row_end and col_start <= col_end) then
    text = vim.api.nvim_buf_get_text(0, row_start - 1, col_start - 1, row_end - 1, col_end, {})
  else
    text = vim.api.nvim_buf_get_text(0, row_end - 1, col_end - 1, row_start - 1, col_start, {})
  end
  enter_translate_cmd(table.concat(text, " "):gsub("%s%s+", " "))
end, { desc = "translate selection" })
