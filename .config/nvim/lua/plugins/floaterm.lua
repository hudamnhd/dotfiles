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

local win = {
  full = "--width=0.95 --height=0.95",
  bottom = "--height=0.4 --wintype=split",
  top = "--height=0.5 --wintype=split --position=leftabove",
}

return {
  "voldikss/vim-floaterm",
  cmd = "FloatermNew",
  submodules = false,
  keys = {
    {
      "<a-g>",
      function()
        toggleFloaterm("--name=gitui " .. win.full .. [[ export GIT_EDITOR=floaterm; gitui]])
      end,
      mode = { "n", "t" },
      desc = "Gitui",
    },
    {
      "<F1>",
      function()
        toggleFloaterm("--name=bash " .. win.bottom .. " bash")
      end,
      mode = { "n", "t" },
      desc = "Bash",
    },
    { "<a-x>", vim.cmd.FloatermKill, mode = "t", desc = "FloatermKill" },
    { "<c-space>", vim.cmd.FloatermHide, mode = "t", desc = "FloatermHide" },
    {
      "<a-b>",
      function()
        toggleFloaterm("--name=buffer --cwd=<buffer> --disposable " .. win.bottom .. " bash")
      end,
      mode = { "n", "t" },
      desc = "Buffer cwd",
    },
  },
}
