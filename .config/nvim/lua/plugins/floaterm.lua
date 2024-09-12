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

local type = {
  f = "--width=0.95 --height=0.95",
  sb = "--height=0.35 --wintype=split",
  sa = "--height=0.4 --wintype=split --position=leftabove",
}

return {
  "voldikss/vim-floaterm",
  cmd = "FloatermNew",
  keys = {
    -- stylua: ignore start
        { "<a-g>", function() toggleFloaterm("--name=gitui " .. type.f .. [[ export GIT_EDITOR=floaterm; gitui]]) end, mode = { "n", "t" }, desc = "Gitui" },
        { "<F1>", function() toggleFloaterm("--name=bash " .. type.sb .." bash") end,   mode = { "n", "t" }, desc = "Bash" },
        { "<F2>", function() toggleFloaterm("--name=bash2 " .. type.sa .." bash") end,   mode = { "n", "t" }, desc = "Bash2" },
        { "<a-x>", vim.cmd.FloatermKill, mode = "t", desc = "FloatermKill" },
        { "<c-space>", vim.cmd.FloatermHide, mode = "t", desc = "FloatermHide" },

    -- { "<a-]>", vim.cmd.FloatermNext, mode = { "n", "t" }, desc = "FloatermNext" },
    -- { "<a-[>", vim.cmd.FloatermPrev, mode = { "n", "t" }, desc = "FloatermPrev" },
    -- { "<a-cr>", vim.cmd.FloatermNew,  mode = { "n", "t" }, desc = "FloatermNew" },

      { "-",     function() toggleFloaterm("--name=yazi " .. type.f .." yazi") end,   mode = "n", desc = "Yazi" },
      { "<c-->", function() toggleFloaterm("--name=lf " .. type.f .." lf") end,       mode = "n", desc = "Lf" },
      { "<a-->", function() toggleFloaterm("--name=broot " .. type.f .." broot") end, mode = "n", desc = "Broot" },
    -- { "", function() toggleFloaterm("--name=buffer --cwd=<buffer> --disposable " .. size.m.." bash") end,     mode = { "n", "t" }, desc = "Buffer cwd" },
    -- stylua: ignore end
  },
}
