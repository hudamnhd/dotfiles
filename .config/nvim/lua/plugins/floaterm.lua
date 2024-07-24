vim.g.floaterm_title = "TERM($1|$2)"
vim.g.floaterm_opener = "edit"

local function get_bufnr_from_name(name)
  local buflist = vim.fn["floaterm#buflist#gather"]()
  for _, bufnr in ipairs(buflist) do
    local bufname = vim.fn.getbufvar(bufnr, "floaterm_name")
    if bufname == name then
      return bufnr
    end
  end
  return -1
end

local function toggleFloaterm(args)
  local name = args:match("--name=([^%s]+)")
  local bufnr = get_bufnr_from_name(name)

  if bufnr == -1 then
    vim.cmd("FloatermNew " .. args)
  else
    vim.cmd("FloatermToggle " .. name)
  end
end

local size = { l = "--width=0.95 --height=0.95", m = "--width=0.5 --height=0.5" }

return {
  -- Alternate https://github.com/tracyone/term.vim
  "voldikss/vim-floaterm",
  config = function()
    vim.keymap.set("t", "<MouseMove>", "<NOP>")
  end,

  keys = {
    -- stylua: ignore start
        { "<F1>",  function() toggleFloaterm("--name=bash " .. size.l .." bash") end,   mode = { "n",   "t" }, desc = "Bash" },
        { "<F2>",  function() toggleFloaterm("--cwd=<buffer> --name=buffer " .. size.m.." bash") end,   mode = { "n" }, desc = "Buffer" },
        { "<F2>",  function() vim.cmd("FloatermKill buffer") end,   mode = { "t" }, desc = "Buffer" },
        { "_", function() toggleFloaterm("--name=yazi " .. size.l .." yazi") end,   mode = { "n" }, desc = "Yazi" },
        { "<a-g>", function() toggleFloaterm("--name=gitui " .. size.l .." gitui") end, mode = { "n", "n" }, desc = "Gitui" },
        { "<space>f", function() toggleFloaterm("--name=broot " .. size.l .." broot") end, mode = { "n" }, desc = "Broot" },
        { "<c-z>", function() vim.cmd("FloatermToggle") end, mode = { "t" }, desc = "FloatermToggle" },
        { "<a-/>", function() vim.cmd("FloatermNew") end, mode = { "n",   "t" }, desc = "FloatermNew" },
        { "<a-.>", function() vim.cmd("FloatermNext") end, mode = { "n",   "t" }, desc = "FloatermNext" },
        { "<a-,>", function() vim.cmd("FloatermPrev") end, mode = { "n",   "t" }, desc = "FloatermPrev" },
    -- stylua: ignore end
  },
}
