local fzf = require("fzf-lua")

local function hl_match(t)
  for _, h in ipairs(t) do
    -- `vim.api.nvim_get_hl_by_name` is deprecated since v0.9.0
    if vim.api.nvim_get_hl then
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = h, link = false })
      if ok and type(hl) == "table" and (hl.fg or hl.bg) then
        return h
      end
    else
      local ok, hl = pcall(vim.api.nvim_get_hl_by_name, h, true)
      -- must have at least bg or fg, otherwise this returns
      -- succesffully for cleared highlights (on colorscheme switch)
      if ok and (hl.foreground or hl.background) then
        return h
      end
    end
  end
end

require("fzf-lua").setup({
  -- file_icon_padding = " ",
  -- dir_icon = "󰉋 ",
  global_git_icons = false,
  global_file_icons = false,
  { "default-title" }, -- base profile
  fzf_opts = { ["--layout"] = "reverse", ["--padding"] = "0,1", ["--info"] = "inline-right" },
  winopts = {
    height = 0.6,
    width = 0.6,
    preview = {
      hidden = "hidden", -- hide the previewer by default
    },
  },
  fzf_colors = function()
    return {
      ["fg"] = { "fg", "Normal" },
      ["fg+"] = { "fg", "Normal" },
      ["bg"] = { "bg", "Normal" },
      ["bg+"] = { "bg", "Visual" },
      ["hl"] = { "fg", "WarningMsg" },
      ["hl+"] = { "fg", "WarningMsg" },
      ["gutter"] = { "bg", "Normal" },
      ["info"] = { "fg", "WarningMsg" },
      ["border"] = { "fg", "TelescopeBorder" },
      ["prompt"] = { "fg", "Special" },
      ["pointer"] = { "fg", "Exception" },
      ["marker"] = { "fg", "WarningMsg" },
      ["spinner"] = { "fg", "WarningMsg" },
      ["header"] = { "fg", "Comment" },
    }
  end,
  hls = function()
    return {
      border = hl_match({ "TelescopeBorder" }),
      preview_border = hl_match({ "TelescopeBorder" }),
    }
  end,
  keymap = {
    builtin = {
      ["<F1>"] = "toggle-help",
      ["<C-a>"] = "toggle-fullscreen",
      ["<C-o>"] = "toggle-preview",
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    },
    fzf = {
      ["alt-a"] = "toggle-all",
      ["ctrl-o"] = "toggle-preview",
      ["ctrl-d"] = "preview-page-down",
      ["ctrl-u"] = "preview-page-up",
    },
  },
  -- Configuration for specific commands.
  files = {
    find_opts = [[-type f -type d -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
    fzf_opts = {
      ["--ansi"] = false,
    },
  },
  git = {
    bcommits = {
      prompt = "logs:",
      actions = {
        ["alt-d"] = function(...)
          fzf.actions.git_buf_vsplit(...)
          vim.cmd("windo diffthis")
          local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
          vim.api.nvim_feedkeys(switch, "t", false)
        end,
      },
    },
  },
  grep = {
    rg_opts = table.concat({
      -- "--hidden",
      "--follow",
      "--smart-case",
      "--column",
      "--line-number",
      "--no-heading",
      "--color=always",
      "-g=!.git/",
      "-e",
    }, " "),
    fzf_opts = {
      ["--info"] = "inline-right",
    },
  },
})

-- stylua: ignore start
if vim.fn.has("nvim") == 1 then
  vim.g.terminal_color_0 = "#2A2A37"
  vim.g.terminal_color_1 = "#E78A4E"
  vim.g.terminal_color_2 = "#99c794"
  vim.g.terminal_color_3 = "#fac863"
  vim.g.terminal_color_4 = "#6699cc"
  vim.g.terminal_color_5 = "#c594c5"
  vim.g.terminal_color_6 = "#5fb3b3"
  vim.g.terminal_color_7 = "#c0caf5"
  vim.g.terminal_color_8 = "#555555"
  vim.g.terminal_color_9 = "#FFA066"
  vim.g.terminal_color_10 = "#99c794"
  vim.g.terminal_color_11 = "#fac863"
  vim.g.terminal_color_12 = "#6699cc"
  vim.g.terminal_color_13 = "#c594c5"
  vim.g.terminal_color_14 = "#5fb3b3"
  vim.g.terminal_color_15 = "#c0caf5"
else
  vim.g.terminal_ansi_colors = {
    "#1a1b26", "#ec5f67", "#99c794", "#fac863",
    "#6699cc", "#c594c5", "#5fb3b3", "#c0caf5",
    "#555555", "#ec5f67", "#99c794", "#fac863",
    "#6699cc", "#c594c5", "#5fb3b3", "#c0caf5",
  }
end

vim.api.nvim_create_user_command("F", function(info) fzf.files({ cwd = info.fargs[1] }) end, { nargs = "?", complete = "dir", desc = "Fuzzy find files.", })

-- stylua: ignore end
