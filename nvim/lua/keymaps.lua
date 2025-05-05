local bind = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local nm, tm, cm, vm, nvm = "n", "t", "c", { "o", "x" }, { "n", "o", "x" }

-- BASIC KEYMAP
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

bind(nvm, "<space>y", [["+y]], { desc = "Yank to clipboard (primary)" })
bind(nvm, "<space>p", [["+p]], { desc = "Paste after from clipboard (primary)" })

bind(vm, "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true })

bind(nvm, "<c-z>", [[%]])
bind(nvm, "<c-l>", [[g_]])
bind(nvm, "<c-h>", [[^]])

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


bind(nm, "zq", [[*Nqz]], { desc = "mc start macro (foward)" })
bind(nm, "<c-0>", mc_macro(), { desc = "mc end or replay macro", expr = true })
bind(vm, "zq", mc_select .. "``qz", { desc = "mc start macro (foward)" })
bind(vm, "<c-0>", mc_macro(mc_select), { desc = "mc end or replay macro", expr = true })
bind(nm, "<c-f>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cword", silent = false })
bind(nm, "<c-s>", [[:'<,'>s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cword", silent = false })
bind(vm, "<c-s>", [[:s///g<left><left><left>]], { desc = "Search Replace", silent = false })
bind(vm, "<c-f>", [[:%s///g<left><left><left>]], { desc = "Search Replace", silent = false })

bind(nm, "<space>q", [[:bd<cr>]], { desc = "buffer delete" })

return M
