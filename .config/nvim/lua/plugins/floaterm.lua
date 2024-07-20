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

local size = "--width=0.95 --height=0.95"

return {
  -- Alternate https://github.com/tracyone/term.vim
  "voldikss/vim-floaterm",
  config = function()
    vim.keymap.set("t", "<MouseMove>", "<NOP>")

  end,


  keys = {
    -- stylua: ignore start
        { "<f1>",  function() toggleFloaterm("--name=bash " .. size .." bash") end,   mode = { "n",   "t" }, desc = "Bash" },
        { "<c-n>", function() toggleFloaterm("--name=yazi " .. size .." yazi") end,   mode = { "n" }, desc = "Yazi" },
        { "<c-p>", function() toggleFloaterm("--name=broot " .. size .." broot") end, mode = { "n" }, desc = "Broot" },
        { "<a-g>", function() toggleFloaterm("--name=gitui " .. size .." gitui") end, mode = { "n",   "t" }, desc = "Gitui" },
        { "<a-t>", function() vim.cmd("FloatermNew") end, mode = { "n",   "t" }, desc = "FloatermNew" },
        { "<c-z>", function() vim.cmd("FloatermToggle") end, mode = { "t" }, desc = "FloatermToggle" },
    -- stylua: ignore end
  },
}
