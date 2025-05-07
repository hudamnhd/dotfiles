local M = {}

-- FIXME: how to handle <>'s, etc.
local escape_characters = '"\\/.*$^~[]'

-- double escaping is required due to interpretation by feedkeys and then search/replace
M.double_escape = function(str)
  return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters)
end

-- taken from: https://github.com/ibhagwan/nvim-lua/blob/f772c7b41ac4da6208d8ae233e1c471397833d64/lua/utils.lua#L96
function M.get_visual_selection(nl_literal)
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))

    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end

    -- exit visual mode
    --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
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

  -- we don't support multi-line selections
  if n > 1 then
    return nil
  end

  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)

  return table.concat(lines, nl_literal and "\\n" or "\n")
end

function M.get_range(callback)
  local old_func = vim.go.operatorfunc
  -- Define a global function for the operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, "[")
    local finish = vim.api.nvim_buf_get_mark(0, "]")

    if not start or not finish then
      print("Invalid marks")
      return
    end

    local start_line = start[1]
    local start_col = start[2] - 1
    local finish_line = finish[1]
    local finish_col = finish[2] + 1

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, finish_line, false)

    if #lines > 0 and start_line == finish_line then
      lines[1] = string.sub(lines[1], start_col + 2, finish_col)
    elseif #lines > 0 then
      if start_line < finish_line then
        if #lines > 0 then
          lines[1] = string.sub(lines[1], start_col + 1)
        end
        if #lines > 1 then
          lines[#lines] = string.sub(lines[#lines], 1, finish_col + 1)
        end
      end
    end

    local text = table.concat(lines, "\n")

    if callback then
      callback(text)
    end

    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  vim.api.nvim_feedkeys("g@", "n", false)
end

M.visual_charwise_selection = function()
  local visual_selection = M.get_visual_selection()

  if visual_selection == nil then
    print("search-replace does not support visual-blockwise selections")
    return
  end

  local backspace_keypresses = string.rep("\\<backspace>", 5)
  local left_keypresses = string.rep("\\<Left>", 2)

  vim.cmd(
    ':call feedkeys(":'
    .. backspace_keypresses
    .. "%s/"
    .. M.double_escape(visual_selection)
    .. "/"
    .. M.double_escape(visual_selection)
    .. "/"
    .. "g"
    .. left_keypresses
    .. '")'
  )
end


local function cgn(pattern)
  feedkeys("<esc>", "v")
  local cmd = vim.api.nvim_replace_termcodes('<CR>N"_cgn', true, false, true)
  vim.api.nvim_feedkeys("/\\V" .. pattern .. cmd, "n", false)
end

local function cgn_action(type)
  return function()
    if type == "v" then
      cgn(require("utils.substitute").get_visual_selection())
    else
      cgn(vim.fn.expand("<cword>"))
    end
  end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~ multiple cursors (sort of) ~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- see: http://www.kevinli.co/p<space>pnosts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript
local mc_select = [[y/\V\C<C-r>=escape(@", '/')<CR><CR>]]
local function mc_macro(selection)
  selection = selection or ""

  return function()
    if vim.fn.reg_recording() == "z" then
      return "q"
    end

    if vim.fn.getreg("z") ~= "" then
      return "n@z"
    end

    return selection .. "*Nqz"
  end
end

bind("n", "<F7>", [[*Nqz]], { desc = "mc start macro (foward)" })
bind("n", "<F8>", mc_macro(), { desc = "mc end or replay macro", expr = true })
bind("v", "<F7>", mc_select .. "``qz", { desc = "mc start macro (foward)" })
bind("v", "<F8>", mc_macro(mc_select), { desc = "mc end or replay macro", expr = true })

bind("n", "<c-n>", cgn_action("n"), { desc = "cgn word" })
bind("v", "<c-n>", cgn_action("v"), { desc = "cgn visual" })

bind("n", "<c-f>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cword", silent = false })
bind("n", "<c-s>", [[:'<,'>s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cword", silent = false })

bind("v", "<c-f>", M.visual_charwise_selection, { desc = "replace visual" })
bind("v", "<c-s>", [[:s///g<left><left><left>]], { desc = "Search Replace", silent = false })

bind("v", "<a-c>", [[:s/\v(\w)(\w*)/\u\1\L\2/g]], { desc = "To capitalize", silent = false })

return M
