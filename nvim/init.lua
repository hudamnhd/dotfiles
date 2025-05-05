local o = vim.opt

o.title          = true -- Change title of window to filename
o.synmaxcol      = 200  -- for `syntax`
o.guicursor      = ""
o.nu             = true
o.relativenumber = true
o.cursorline     = true
o.tabstop        = 4
o.softtabstop    = 4
o.shiftwidth     = 4
o.expandtab      = true
o.smartindent    = true
o.wrap           = false
o.swapfile       = false
o.backup         = false
o.inccommand     = 'split'
o.hlsearch       = false
o.incsearch      = true
o.termguicolors  = true
o.scrolloff      = 8
o.updatetime     = 50
o.textwidth      = 80
o.formatoptions  = 'rqnl1j' -- Improve comment editing
o.foldmethod     = "indent"
o.foldenable     = true
o.foldlevel      = 99

o.guicursor = {
  "n-v-c-sm:block-Cursor", -- Use 'Cursor' highlight for normal, visual, and command modes
  "i-ci-ve:ver25-lCursor", -- Use 'lCursor' highlight for insert and visual-exclusive modes
  "r-cr:hor20-CursorIM",   -- Use 'CursorIM' for replace mode
}

vim.cmd.colorscheme("default")

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
bind(nm, "<space>s", vim.cmd.vsplit, { desc = "split" })
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
