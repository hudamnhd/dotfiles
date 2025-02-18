local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local getTextSubOptions = require("user.nui.popup-options").getTextSubOptions

local function get_visual_selection()
  local textStart = vim.fn.getpos("'<") -- [bufnum, lnum, col, off]
  local textEnd = vim.fn.getpos("'>") -- [bufnum, lnum, col, off]

  return {
    text = string.sub(vim.fn.getline(textStart[2]), textStart[3], textEnd[3]),
    position = { textStart[2], textStart[3] - 1 },
  }
end

local utils = require("utils.search-replace")

local function local_replace(rtype)
  local opts = {
    replacer = rtype, -- Tipe replace: "normal" atau "global"
    last_mode = vim.fn.mode(),
    active_win = vim.api.nvim_get_current_win(), -- Simpan window aktif
    last_position = vim.api.nvim_win_get_cursor(0),
    current_text = vim.fn.expand("<cword>"),
    replace_ui_format = "/g",
    replace_flags = "/g",
    rep_count = 2,
  }

  if opts.last_mode == "v" then
    opts.current_text = utils.get_visual_selection()
  end

  opts.replace_ui_format = (opts.replacer == "normal") and ":s/p/r" .. opts.replace_ui_format
    or ":%s/p/r" .. opts.replace_ui_format

  local function on_submit(new_text, use_cr)
    vim.api.nvim_set_current_win(opts.active_win)

    if opts.last_mode == "v" then
      local visual_selection = get_visual_selection()
      opts.current_text = visual_selection.text
      opts.last_position = visual_selection.position
    end

    local command_map = {
      normal = "'<,'>s/",
      global = "%s/",
    }

    local command = command_map[opts.replacer] or "%s/"

    local full_command = ':call feedkeys(":'
      .. command
      .. utils.double_escape(opts.current_text)
      .. "/"
      .. utils.double_escape(new_text)
      .. opts.replace_flags

    local crkey = vim.api.nvim_replace_termcodes(use_cr and "<CR>" or "<Left>", true, false, true)
    full_command = full_command .. (use_cr and crkey or string.rep(crkey, opts.rep_count)) .. '")'

    vim.cmd(full_command)
    vim.api.nvim_win_set_cursor(opts.active_win, opts.last_position)
    vim.cmd("noh")
  end

  local input_length = math.max(string.len(opts.current_text), 50)
  local default_value = (opts.replacer == "clear_default") and "" or opts.current_text
  local crrentValue = ""

  local input = Input(getTextSubOptions("Local Replace " .. opts.replace_ui_format, input_length), {
    on_submit = function(newText)
      on_submit(newText, true)
    end,
    on_change = function(newText)
      crrentValue = newText
    end,
    prompt = "❯ ",
    default_value = default_value,
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
    on_submit(crrentValue, false)
    input.input_props.on_close()
  end, { noremap = true, silent = false })

  input:on(event.BufLeave, input.input_props.on_close, { once = true })
end

return local_replace
