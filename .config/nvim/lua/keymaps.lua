---@diagnostic disable: codestyle-check
local M = {}

local utils = require("utils")
local k = utils.keymap
local bind, feedkeys = k.bind, k.feedkeys
local nm, tm, cm, vm, nvm = "n", "t", "c", { "o", "x" }, { "n", "o", "x" }

M.leader_group_clues = {
  { mode = "n", keys = "st", desc = "+Toggle and other" },
  { mode = "n", keys = "<space>b", desc = "+Buffer" },
  { mode = "n", keys = "<space>g", desc = "+Git and Debug" },
  { mode = "n", keys = "<space>d", desc = "+Debugprint" },
}

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

-- NOTE without copying to clipboard
local blackhole_key = { "S", "D", "C", "d" }
for _, key in ipairs(blackhole_key) do
  bind(nm, key, '"_' .. key, { desc = "blackhole" .. key })
end

local function delete_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end

local function split_sensibly()
  if vim.api.nvim_win_get_width(0) > math.floor(vim.api.nvim_win_get_height(0) * 2.3) then
    vim.cmd("vs")
  else
    vim.cmd("split")
  end
end

-- BASIC
-- stylua: ignore start
bind(nm, "zq",    [[*Nqz]],            { desc = "mc start macro (foward)" } )
bind(nm, "<c-0>", mc_macro(),          { desc = "mc end or replay macro", expr = true } )

bind(vm, "zq",    mc_select .. "``qz", { desc = "mc start macro (foward)" } )
bind(vm, "<c-0>", mc_macro(mc_select), { desc = "mc end or replay macro", expr = true  } )

bind(tm, [[<c-\>]], [[<C-\><C-n>]] )
bind(tm, [[<a-x>]], [[<C-\><C-n>:bd!<Cr>]] )
bind(tm, [[<a-w>]], [[<C-\><C-n><c-w>w]] )
bind(tm, [[<a-r>]], [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true } )

bind(cm, "<c-x>", [[!chmod +x <c-r>%]], { silent = false } )
bind(cm, "<c-v>", [[<C-R>"]], { silent = false } )
bind(cm, "<a-v>", [[<C-R>+]], { silent = false } )

bind(cm, "<F1>", [[\(.*\)<Left><Left>]], { silent = false })
bind(cm, "<F2>", [[\<\><Left><Left>]],   { silent = false })
bind(cm, "<F3>", [[.\{-}]],              { silent = false } ) --\s\+

bind(cm, "<Insert>", 'getcmdtype() == ":" ? expand("%:p")  : ""', { silent = false, expr = true } )

bind(cm, "=",  [[getcmdtype() == ':' && getcmdline() == '' ? 'lua=' : '=']], { silent = false, expr = true })

bind(vm, "<c-f>", [[<cmd>lua require("utils.search-replace").visual_charwise_selection()<cr>]], { desc = "replace visual" } )
bind(vm, "<c-s>", [[:s///g<left><left><left>]],          { desc = "Search Replace", silent = false  } )
bind(nm, "<c-f>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],     { desc = "Replace cword", silent = false } )
bind(nm, "<c-s>", [[:'<,'>s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cword", silent = false } )

bind(vm, "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true } )
bind(vm, ">", [[>gv]] )
bind(vm, "<", [[<gv]] )
bind(nm, ">", [[<cmd>lua require("utils.helper").toggle_qf("q")<cr>]] )
bind(nm, "<", [[<cmd>lua require("utils.helper").toggle_qf("l")<cr>]] )

bind(nm, "!",     [[:<up><cr>]] )
bind(nm, "<a-w>", [[<c-w>w]] )
bind(nm, "<esc>", [[<Cmd>nohlsearch|diffupdate|echo<cr>]] )

bind(nm, "<space>c", vim.cmd.close,  { desc = "Close" } )
bind(nm, "<space>o", vim.cmd.only,  { desc = "Only" } )
bind(nm, "<space>v", split_sensibly, { desc = "split" } )
bind(nm, "<space>w", vim.cmd.write,  { desc = "Write" } )

bind(nm, "J", [['mz' . v:count1 . 'J`z']], { desc = "Join", expr = true } )

bind(nm, "cl", [[mzguiw`z]],    { desc = "UPPERCASE to lowercase" } )
bind(nm, "ct", [[mzguiwgUl`z]], { desc = "Titlecase" } )
bind(nm, "cu", [[mzgUiw`z]],    { desc = "lowercase to UPPERCASE" } )
bind(nm, "dd", delete_line,     { desc = "delete line", expr = true  } )

bind(nvm, "0", ":", { silent = false })

bind(nvm, "c", [["_c]] )
bind(nvm, "x", [["_x]] )

bind(nvm, "gy", [["+y]], { desc = "Yank to clipboard (primary)" } )
bind(nvm, "gp", [["+p]], { desc = "Paste after from clipboard (primary)" } )

bind(nvm, "<c-z>", [[%]] )
bind(nvm, "<c-l>", [[g_]] )
bind(nvm, "<c-h>", [[^]] )

-- PLUGIN
bind(nm, "std", [[<cmd>lua require("utils.helper").toggle_diff_buff()<cr>]], { desc = "Toggle 'Diff'" } )
bind(nm, "sth", [[<cmd>lua require("mini.hipatterns").toggle()<cr>]],        { desc = "Toggle 'Hipatterns'" } )
bind(nm, "sto", [[<cmd>lua require("mini.diff").toggle_overlay()<cr>]],      { desc = "Toggle 'Overlay'" } )

bind(nm, "<space>t", [[<cmd>lua require("utils.translate").translate_nm()<cr>]],  { desc = "Toggle 'translate normal'" } )
bind(vm, "<space>t", [[<cmd>lua require("utils.translate").translate_vm()<cr>]],  { desc = "Toggle 'translate visual'" } )

bind(nm, "<space>%", [[<cmd>lua require("utils.helper").set_cwd()<cr>]], { desc = "Toggle 'Set cwd'" } )
bind(nm, "<space>u", [[<cmd>UndotreeToggle<cr>]],                        { desc = "Toggle 'Undotree'" } )
bind(nm, "<space>y", [[<cmd>Unite -vertical yankround<cr>]],             { desc = "Toggle 'Yankround'" } )


local delimiters = { ",", ";", "." }

local function modify_line_end_delimiter(character)
  return function()
    local line = vim.api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == character then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delimiters, last_char) then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      vim.api.nvim_set_current_line(line .. character)
    end
  end
end

for _, key in ipairs(delimiters) do
  local key_combination = string.format("z%s", key)
  local desc_combination = string.format("add '%s' to end of line", key)
  vim.keymap.set("n", key_combination, modify_line_end_delimiter(key), { desc = desc_combination })
end


local function cgn(pattern)
  feedkeys("<esc>", "v")
  local cmd = vim.api.nvim_replace_termcodes('<CR>N"_cgn', true, false, true)
  vim.api.nvim_feedkeys("/\\V" .. pattern .. cmd, "n", false)
end

local function cgn_action(type)
  return function()
    if type == "v" then
      cgn(require("utils.search-replace").get_visual_selection())
    else
      cgn(vim.fn.expand("<cword>"))
    end
  end
end

bind(nm, "<c-n>", cgn_action("n"), { desc = "cgn word" })
bind(vm, "<c-n>", cgn_action("v"), { desc = "cgn visual" })

local function special_up()
  local cursorline = vim.fn.line('.')
  local first_visible = vim.fn.line('w0')
  local travel = math.floor(vim.api.nvim_win_get_height(0) / 2)

  if (cursorline - travel) < first_visible then
    vim.cmd("execute \"normal! " .. travel .. "\\<C-y>\"")
  else
    vim.cmd("execute \"normal! " .. travel .. "\\k\"")
  end
end

local function special_down()
  local cursorline = vim.fn.line('.')
  local last_visible = vim.fn.line('w$')
  local travel = math.floor(vim.api.nvim_win_get_height(0) / 2)

  if (cursorline + travel) > last_visible and last_visible < vim.fn.line('$') then
    vim.cmd("execute \"normal! " .. travel .. "\\<C-e>\"")
  elseif cursorline < last_visible then
    vim.cmd("execute \"normal! " .. travel .. "\\j\"")
  end
end

vim.keymap.set({ 'n', 'x' }, '<c-u>', function() special_up() end)
vim.keymap.set({ 'n', 'x' }, '<c-d>', function() special_down() end)
return M
