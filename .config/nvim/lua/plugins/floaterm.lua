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

local size = { l = "--width=0.95 --height=0.95", m = "--width=0.5 --height=0.3 --wintype=split" }

return {
  "voldikss/vim-floaterm",
  cmd = "FloatermNew",
  keys = {
    -- stylua: ignore start

        { "<a-b>", function() toggleFloaterm("--cwd=<buffer> --name=buffer " .. size.m.." bash") end, mode = { "n" }, desc = "Buffer" },
        { "<a-b>", function() vim.cmd("FloatermKill buffer") end, mode = { "t" }, desc = "Buffer" },

        { "<c-n>", function() toggleFloaterm("--name=yazi " .. size.l .." yazi") end,   mode = { "n" }, desc = "Yazi" },
        { "<c-p>", function() toggleFloaterm("--name=broot " .. size.l .." broot") end, mode = { "n" }, desc = "Broot" },

        { "<a-t>", function() toggleFloaterm("--name=bash " .. size.m .." bash") end,   mode = { "n", "t" }, desc = "Bash" },
        { "<a-g>", function() toggleFloaterm("--name=gitui " .. size.l .. [[ export GIT_EDITOR=floaterm; gitui]]) end, mode = { "n", "t" }, desc = "Gitui" },

        { "<c-z>", function() vim.cmd("FloatermToggle") end, mode = { "t" }, desc = "FloatermToggle" },

        { "<a-/>", function() vim.cmd("FloatermNew") end,  mode = { "n", "t" }, desc = "FloatermNew" },
        { "<a-.>", function() vim.cmd("FloatermNext") end, mode = { "n", "t" }, desc = "FloatermNext" },
        { "<a-,>", function() vim.cmd("FloatermPrev") end, mode = { "n", "t" }, desc = "FloatermPrev" },
    -- stylua: ignore end
  },
}
