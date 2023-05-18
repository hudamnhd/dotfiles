-- custom key maps disini
local function map(mode, l, r, desc)
	vim.keymap.set(mode, l, r, { desc = desc })
end
-- ini adalah contoh
--map("n", "]h", '<cmd>lua print("Testing")<cr>', "Testing Mapping")
map("n", "<F1>", '<cmd>NvimTreeToggle<cr>', "Explorer")
map("n", "<Tab>", '<cmd>bnext<cr>', "Next buffer")
map("n", "]z", '<cmd>set colorcolumn=0<cr>', "Hide line")