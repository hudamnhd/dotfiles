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

local size = {
    l = "--width=0.95 --height=0.95",
    m = "--width=0.5 --height=0.3 --wintype=split"
  }

return {
  "voldikss/vim-floaterm",
  cmd = "FloatermNew",
  keys = {
    -- stylua: ignore start
        { "<a-g>", function() toggleFloaterm("--name=gitui " .. size.l .. [[ export GIT_EDITOR=floaterm; gitui]]) end, mode = { "n", "t" }, desc = "Gitui" },

        { "-", function() toggleFloaterm("--name=yazi " .. size.l .." yazi") end,   mode = "n", desc = "Yazi" },
        { "<space>f", function() toggleFloaterm("--name=broot " .. size.l .." broot") end, mode = { "n" },      desc = "Broot" },

        { "<F1>", function() toggleFloaterm("--name=bash " .. size.m .." bash") end,   mode = { "n", "t" }, desc = "Bash" },

        { "<a-x>", vim.cmd.FloatermKill, mode = "t", desc = "FloatermKill" },
        { "<a-z>", vim.cmd.FloatermHide, mode = "t", desc = "FloatermToggle" },

        { "<a-n>", vim.cmd.FloatermNext, mode = { "n", "t" }, desc = "FloatermNext" },
        { "<a-p>", vim.cmd.FloatermPrev, mode = { "n", "t" }, desc = "FloatermPrev" },
        { "<a-cr>", vim.cmd.FloatermNew,  mode = { "n", "t" }, desc = "FloatermNew" },

    -- { "_", function() toggleFloaterm("--name=lf " .. size.l .." lf") end,   mode = "n", desc = "Lf" },
    -- { "<F2>", function() toggleFloaterm("--name=buffer --cwd=<buffer> --disposable " .. size.m.." bash") end,     mode = { "n", "t" }, desc = "Buffer cwd" },
    -- stylua: ignore end
  },
}
