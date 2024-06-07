local fzf_lua = require("fzf-lua")
local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
local core = require("fzf-lua.core")
local path = require("fzf-lua.path")

-- return first matching highlight or nil
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

vim.env.FZF_DEFAULT_OPTS = table.concat({
  -- "--bind=ctrl-u:page-up,ctrl-d:page-down",
  '--pointer=" "',
  '--marker="*"',
  '--no-separator',
  "--layout=reverse",
  "--padding=0,1",
  "--sort 10000",
  -- "--reverse --no-separator --color=bg+:#1E1E2E,bg:#1E1E2E,spinner:#F5E0DC,hl:#89B4FA,fg:#CDD6F4,header:#A6ADC8,info:#CBA6F7,pointer:#F5E0DC,marker:#F5E0DC,fg+:#CDD6F4,prompt:#89B4FA,hl+:#89B4FA",
  -- "--color=query:#D4BE98,bg+:#1F1F28,bg:#1F1F28,spinner:#D8A657,hl:#E78A4E,fg:#D4BE98,header:#928374,info:#89B482,pointer:#af5fff,marker:#87ff00,fg+:#E6C384,prompt:#E78A4E,hl+:#E78A4E",
  -- "--color=fg:#d0d0d0,fg+:#d0d0d0,bg:#121212,bg+:#262626,hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00,prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf,border:#262626,label:#aeaeae,query:#d9d9d9",
}, " ")

local default_opts = {
  file_icon_padding = " ",
    fzf_colors = function()
        return {
        ['fg']      = { 'fg', 'Normal' },
        ['bg']      = { 'bg', 'Normal' },
        ['bg+']     = { 'bg', 'Visual' },
        ['hl']      = { 'fg', 'WarningMsg' },
        ['hl+']     = { 'fg', 'WarningMsg' },
        ['gutter']  = { 'bg', 'Normal' },
        ['info']    = { 'fg', 'WarningMsg' },
        ['border']  = { 'fg', 'LineNr' },
        ['prompt']  = { 'fg', 'Function' },
        ['pointer'] = { 'fg', 'Exception' },
        ['marker']  = { 'fg', 'WarningMsg' },
        ['spinner'] = { 'fg', 'WarningMsg' },
        ['header']  = { 'fg', 'Comment' },
          }
        end,
        winopts = {
          split = "botright new", -- open in a full-height split on the far right
          -- height = 0.9,
          -- width = 0.8,
          preview        = {
            default      = "bat",
            -- layout       = "flex",
            -- horizontal = "down:50%",
            flip_columns = 130,
            scrollbar    = "float",
            delay        = 60, -- smoother preview experience
            -- hidden = "hidden", -- hide the previewer by default
          },


          border = "rounded",
        },
        hls = function()
          return {
            border = hl_match({ "Comment" }),
            preview_border = hl_match({ "Comment" }),
          }
        end,
        previewers = {
          bat = {
            cmd = "bat",
            args = "--color=always --style=numbers,changes",
            -- uncomment to set a bat theme, `bat --list-themes`
             -- theme = "FzfxNvimOnedark",
          },
          builtin = {
            title_fnamemodify = function(s)
              return s
            end,
            extensions = {
              ["gif"] = { "chafa" },
              ["png"] = { "chafa" },
              ["jpg"] = { "chafa" },
              ["jpeg"] = { "chafa" },
              ["svg"] = { "chafa" },
            },
          },
        },
        actions = {
          files = {
            ["default"] = fzf_lua.actions.file_edit,
            ["ctrl-l"] = fzf_lua.actions.arg_add,
            ["ctrl-s"] = fzf_lua.actions.file_split,
            ["ctrl-v"] = fzf_lua.actions.file_vsplit,
            ["ctrl-t"] = fzf_lua.actions.file_tabedit,
            ["ctrl-q"] = fzf_lua.actions.file_sel_to_qf,
            ["alt-q"] = fzf_lua.actions.file_sel_to_ll,

            -- open a DREX buffer for the cwd
            ["alt-d"] = function(_, opts)
              require("drex").open_directory_buffer(opts.cwd)
            end,
            -- start a live grep search from the cwd
            ["alt-s"] = {
              function(_, opts)
                fzf.live_grep({ cwd = opts.cwd })
              end,
            },
            -- select from buffers rooted in the cwd
            ["alt-b"] = {
              function(_, opts)
                fzf.buffers({
                  cwd = opts.cwd,
                  fzf_opts = {
                    -- no header lines, make every entry selectable
                    ["--header-lines"] = false,
                  },
                })
              end,
            },
          },
          buffers = {
            ["default"] = fzf_lua.actions.file_edit,
          },
        },
        files = {
          -- uncomment to override .gitignore
          -- fd_opts = "--no-ignore --color=never --type f --hidden --follow --exclude .git",
          fzf_opts = { ["--tiebreak"] = "end" },
          actions = { ["ctrl-g"] = { fzf_lua.actions.toggle_ignore } },
          git_icons = false, -- remove git icons for better performance
          winopts = {
          height = 0.55,
          width = 0.5,
            preview = {
              hidden = "hidden", -- hide the previewer by default
            },
          },
        },
        oldfiles = {
          git_icons = false, -- remove git icons for better performance
          winopts = {
          height = 0.55,
          width = 0.5,
            preview = {
              hidden = "hidden", -- hide the previewer by default
            },
          },
        },
        buffers = {
          winopts = {
          height = 0.55,
          width = 0.5,
            preview = {
              hidden = "hidden", -- hide the previewer by default
            },
          },
        },
        grep = {
          git_icons = false, -- remove git icons for better performance
          debug = false,
          rg_glob = true,
          rg_opts = "--hidden --column --line-number --no-heading"
          .. " --color=always --smart-case -g '!.git' -e",
        },
        git = {
          status = {
            cmd = "git status -su",
            winopts = {
              preview = { vertical = "down:70%", horizontal = "right:70%" },
            },
            preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
          },
          commits = {
            winopts = { preview = { vertical = "down:70%", horizontal = "right:70%" } },
            preview_pager = vim.fn.executable("delta") == 1 and "delta --width=${COLUMNS:-0}",
          },
          bcommits = {
            prompt = "logs:",
            -- cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen%><(12)%cr%><|(12)%Creset %s' <file>",
            -- preview = "git show --stat --color --format='%C(cyan)%an%C(reset)%C(bold yellow)%d%C(reset): %s' {1} -- <file>",
            actions = {
              ["ctrl-d"] = function(...)
                fzf.actions.git_buf_vsplit(...)
                vim.cmd("windo diffthis")
                local switch = vim.api.nvim_replace_termcodes("<C-w>h", true, false, true)
                vim.api.nvim_feedkeys(switch, "t", false)
              end,
            },
            preview_opts = "nohidden",
            winopts = {
              preview = { vertical = "down:75%", horizontal = "right:75%" },
            },
          },
          branches = {
            winopts = {
              preview = { vertical = "down:75%", horizontal = "right:75%" },
            },
          },
        },
        lsp = {
          finder = {
            providers = {
              { "definitions", prefix = fzf_lua.utils.ansi_codes.green("def ") },
              { "declarations", prefix = fzf_lua.utils.ansi_codes.magenta("decl") },
              { "implementations", prefix = fzf_lua.utils.ansi_codes.green("impl") },
              { "typedefs", prefix = fzf_lua.utils.ansi_codes.red("tdef") },
              { "references", prefix = fzf_lua.utils.ansi_codes.blue("ref ") },
              { "incoming_calls", prefix = fzf_lua.utils.ansi_codes.cyan("in  ") },
              { "outgoing_calls", prefix = fzf_lua.utils.ansi_codes.yellow("out ") },
            },
          },
          symbols = {
            path_shorten = 1,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
        diagnostics = { file_icons = false, path_shorten = 1 },
      }

      return {
        setup = function()
          -- NOT NEEDED since fzf-lua commit 604eadf
          -- custom devicons setup file to be loaded when `multiprocess = true`
          -- fzf_lua.config._devicons_setup = "~/.config/nvim/lua/plugins/devicons/setup.lua"

          fzf_lua.setup(default_opts)

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
              "#1a1b26",
              "#ec5f67",
              "#99c794",
              "#fac863",
              "#6699cc",
              "#c594c5",
              "#5fb3b3",
              "#c0caf5",
              "#555555",
              "#ec5f67",
              "#99c794",
              "#fac863",
              "#6699cc",
              "#c594c5",
              "#5fb3b3",
              "#c0caf5",
            }
          end
        end,
      }
