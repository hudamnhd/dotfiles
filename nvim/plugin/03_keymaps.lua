-- vim mode
local nm, tm, cm, vm, nvm = "n", "t", "c", { "o", "x" }, { "n", "o", "x" }
local nvo = "" -- NOTE: mode "" represents "nvo"

-- disable key
local nop_key = { "s", "c", "<c-z>", "<space>" }

for _, key in ipairs(nop_key) do
  bind("", key, "<Nop>")
end

-- without copying to clipboard (blackhole)
local bh_key = { "S", "D", "C", "d" }

for _, key in ipairs(bh_key) do
  bind(nm, key, '"_' .. key)
end

-- safe delete line
local function del_line()
  local empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  return (empty_line and '"_dd' or "dd")
end

-- BASIC KEYMAP
bind(nm, "dd", del_line, { desc = "delete line", expr = true })

bind(tm, [[<c-\>]], [[<C-\><C-n>]])
bind(tm, [[<a-x>]], [[<C-\><C-n>:bd!<Cr>]])
bind(tm, [[<a-w>]], [[<C-\><C-n><c-w>w]])
bind(tm, [[<a-r>]], [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

bind(cm, "<c-v>", [[<C-R>"]], { silent = false })
bind(cm, "<a-v>", [[<C-R>+]], { silent = false })

bind(cm, "<F1>", [[\(.*\)<Left><Left>]], { silent = false })
bind(cm, "<F4>", 'getcmdtype() == ":" ? expand("%:p")  : ""', { silent = false, expr = true })

bind(vm, ">", [[>gv]])
bind(vm, "<", [[<gv]])

bind(nm, "!", [[:<up><cr>]])
bind(nm, "<a-w>", [[<c-w>w]])

bind(nm, "<space>c", vim.cmd.close, { desc = "split" })
bind(nm, "<space>v", vim.cmd.vsplit, { desc = "split" })
bind(nm, "<space>w", vim.cmd.write, { desc = "Write" })

bind(nm, "J", [['mz' . v:count1 . 'J`z']], { desc = "Join", expr = true })

bind(nm, "cl", [[mzguiw`z]], { desc = "UPPERCASE to lowercase" })
bind(nm, "ct", [[mzguiwgUl`z]], { desc = "Titlecase" })
bind(nm, "cu", [[mzgUiw`z]], { desc = "lowercase to UPPERCASE" })

bind(nvm, "0", ":", { silent = false })

bind(nvm, "c", [["_c]])
bind(nvm, "x", [["_x]])
-- Edgemotion
bind(nvo, '<c-j>', '<Plug>(edgemotion-j)', {})
bind(nvo, '<c-k>', '<Plug>(edgemotion-k)', {})

bind(nvm, "<space>y", [["+y]], { desc = "Yank to clipboard (primary)" })
bind(nvm, "<space>p", [["+p]], { desc = "Paste after from clipboard (primary)" })

bind(vm, "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true })

bind(nvm, "<c-z>", [[%]])
bind(nvm, "<c-l>", [[g_]])
bind(nvm, "<c-h>", [[^]])

-- Git
bind(nm, "<c-Space>", [[<cmd>vert Git<cr>]], { desc = "Git" })
bind(nm, "<space>ga", vim.cmd.Gwrite, { desc = "Git add" })
bind(nm, "<space>gr", vim.cmd.Gread, { desc = "Git reset" })
bind(nm, "<space>gd", vim.cmd.Gvdiffsplit, { desc = "Git diff" })
bind(nm, '<space>go', [[<Cmd>lua MiniDiff.toggle_overlay()<CR>]], { desc = 'Toggle overlay' })

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
