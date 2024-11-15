local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local getTextSubOptions = require("user.nui.popup-options").getTextSubOptions

local function getVisualSelection()
  local textStart = vim.fn.getpos("'<") -- [bufnum, lnum, col, off]
  local textEnd = vim.fn.getpos("'>") -- [bufnum, lnum, col, off]

  return {
    text = string.sub(vim.fn.getline(textStart[2]), textStart[3], textEnd[3]),
    position = { textStart[2], textStart[3] - 1 },
  }
end

local util = require("utils.search-replace")

local function local_replace(rtype)
  print(rtype)
  local lastMode = vim.fn.mode()
  local active_win = vim.api.nvim_get_current_win() -- Simpan window aktif sebelumnya
  local lastPosition = vim.api.nvim_win_get_cursor(0)
  local currentText = vim.fn.expand("<cword>")

  if lastMode == "v" then
    currentText = util.get_visual_selection()
  end

  local type_ui = "/g"
  local type = "/g"
  local rep_count = 2

  if rtype == "normal" then
    type_ui = ":s/" .. "p/r" .. type_ui
  else
    type_ui = ":%s/" .. "p/r" .. type_ui
  end

  local function onSubmit(newText, use_cr)
    -- Pindahkan kembali fokus ke window aktif sebelumnya (jika dari Quickfix)
    vim.api.nvim_set_current_win(active_win)

    if lastMode == "v" then
      local visualSelection = getVisualSelection()
      currentText = visualSelection.text
      lastPosition = visualSelection.position
    end

    local command
    if rtype == "normal" then
      command = "'<,'>s/"
    elseif rtype == "global" then
      command = "%s/"
    else
      command = "%s/"
    end

    local full_command = ':call feedkeys(":'
      .. command
      .. util.double_escape(currentText)
      .. "/"
      .. util.double_escape(newText)
      .. type

    -- Tambah CR key hanya jika `use_cr` true
    if use_cr then
      local crkey = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
      full_command = full_command .. crkey
    else
      local crkey = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
      local left_keypresses = string.rep(crkey, rep_count)
      full_command = full_command .. left_keypresses
    end

    full_command = full_command .. '")'

    vim.cmd(full_command)

    -- Kembalikan posisi kursor ke posisi sebelumnya
    vim.api.nvim_win_set_cursor(active_win, lastPosition)

    vim.cmd("noh")
  end

  local inputLength = string.len(currentText)
  inputLength = inputLength > 50 and inputLength + 2 or 50

  local defaultValue = (rtype == "clear_default") and "" or currentText
  local crrentValue = ""

  local input = Input(getTextSubOptions("Local Replace " .. type_ui, inputLength), {
    on_submit = function(newText)
      onSubmit(newText, true)
    end,
    on_change = function(newText)
      crrentValue = newText
    end,
    prompt = "❯ ",
    default_value = defaultValue,
  })

  input:mount()

  -- Mapping untuk menutup dengan Ctrl-c dan q
  for _, mode in ipairs({ "n", "i" }) do
    input:map(mode, "<c-c>", input.input_props.on_close, { noremap = true })
  end
  for _, mode in ipairs({ "n" }) do
    input:map(mode, "q", input.input_props.on_close, { noremap = true })
  end

  -- Mapping khusus untuk Ctrl-e, tanpa CR key
  input:map("i", "<c-e>", function()
    -- False untuk tidak menambah CR key
    onSubmit(crrentValue, false)
    input.input_props.on_close()
  end, { noremap = true, silent = false })

  input:on(event.BufLeave, input.input_props.on_close, { once = true })
end

return local_replace
