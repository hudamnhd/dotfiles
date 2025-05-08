local nvo = "" -- NOTE: mode "" represents "nvo"

-- disable key
local nop_key = { "s", "c", "<c-z>", "<space>" }

for _, key in ipairs(nop_key) do
  bind(nvo, key, "<Nop>")
end

-- without copying to clipboard (blackhole)
local bh_key = { "S", "D", "C", "d" }

for _, key in ipairs(bh_key) do
  bind("n", key, '"_' .. key)
end

-- Safe delete line
local function del_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end

bind("n", "dd", del_line, { desc = "delete line", expr = true })

bind("n", "J", [['mz' . v:count1 . 'J`z']], { desc = "Join", expr = true })

bind("n", "cl", [[mzguiw`z]], { desc = "UPPERCASE to lowercase" })
bind("n", "ct", [[mzguiwgUl`z]], { desc = "Titlecase" })
bind("n", "cu", [[mzgUiw`z]], { desc = "lowercase to UPPERCASE" })

bind("x", "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true })

-- Remap (Easy to reach)
bind("c", [[<F1>]], [[\(.*\)<Left><Left>]], { silent = false })
bind("c", [[<F4>]], 'getcmdtype() == ":" ? expand("%:p")  : ""', { silent = false, expr = true })
bind("c", [[<c-v>]], [[<C-R>"]], { silent = false })
bind("c", [[<a-v>]], [[<C-R>+]], { silent = false })
bind("t", [[<c-\>]], [[<C-\><C-n>]])
bind("t", [[<a-x>]], [[<C-\><C-n>:bd!<Cr>]])
bind("t", [[<a-r>]], [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })
bind("t", [[<a-w>]], [[<C-\><C-n><c-w>w]])
bind("n", [[<a-w>]], [[<c-w>w]])

bind("n", [[!]], [[:<up><cr>]])
bind("x", [[>]], [[>gv]])
bind("x", [[<]], [[<gv]])
bind(nvo, [[0]], [[:]], { silent = false })

bind(nvo, [[<c-z>]], [[%]])
bind(nvo, [[<c-l>]], [[g_]])
bind(nvo, [[<c-h>]], [[^]])

bind("n", [[<space>c]], vim.cmd.close, { desc = "Close" })
bind("n", [[<space>v]], vim.cmd.vsplit, { desc = "Vsplit" })
bind("n", [[<space>w]], vim.cmd.write, { desc = "Write" })

bind(nvo, "<space>y", [["+y]], { desc = "Yank to clipboard (primary)" })
bind(nvo, "<space>p", [["+p]], { desc = "Paste after from clipboard (primary)" })

-- Blackhole
bind(nvo, "c", [["_c]])
bind(nvo, "x", [["_x]])

-- Edgemotion
bind(nvo, '<c-j>', '<Plug>(edgemotion-j)', {})
bind(nvo, '<c-k>', '<Plug>(edgemotion-k)', {})

-- EasyAlign
bind('n', 'ga', '<Plug>(EasyAlign)', { desc = "EasyAlign" })
bind('x', 'ga', '<Plug>(EasyAlign)', { desc = "EasyAlign" })

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
  local key_combination = string.format("d%s", key)
  local desc_combination = string.format("add '%s' to end of line", key)
  bind("n", key_combination, modify_line_end_delimiter(key), { desc = desc_combination })
end
