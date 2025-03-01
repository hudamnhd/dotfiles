return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        floats = "normal",
      },
      sidebars = { "qf", "help", "terminal" },
      on_highlights = function(highlights, c)
        for _, defn in pairs(highlights) do
          if defn.undercurl then
            defn.undercurl = false
            defn.underline = true
          end
        end
        -- for tokyonight
        highlights.LineNr = { fg = "#5D6293" }
        -- highlights.TabLineIndexSel = { fg = c.bg, bg = c.blue, bold = true }
        -- highlights.MiniStatuslineDevinfo = { fg = "#c8d3f5", bg = "#292C42" }
        -- highlights.MiniStatuslineFilename = { fg = "#c8d3f5" }
        -- highlights.MiniStatuslineFileinfo = { fg = "#c8d3f5", bg = "#292C42" }
        -- highlights.MiniTablineCurrent = { fg = "#c8d3f5", bg = "#292C42" }
        -- highlights.MiniTablineTabpagesection = { fg = "#c8d3f5", bg = "#292C42" }
        -- highlights.MiniTablineModifiedCurrent = { fg = "#ffc777", bg = "#292C42" }
        highlights.LeapMatch = { fg = "#c3e88d", bg = "#292C42" }
        highlights.LeapLabel = { fg = "#292C42", bg = "#c3e88d" }
        highlights.LeapBackdrop = { fg = "none", bg = "none" }
        highlights.LeapLabelDimmed = { fg = "#4fd6be", bg = "#292C42" }
        highlights.TabLine = { fg = c.comment, bg = c.bg_statusline }
        highlights.TabLineSel = { fg = c.bg, bg = c.blue }
        highlights.TabLineModifiedSel = { fg = c.bg, bg = c.warning }
        highlights.TabLineIndexSel = { fg = c.bg, bg = c.blue, bold = true }
        highlights.TabLineIndexModifiedSel = { fg = c.bg, bg = c.warning, bold = true }
        highlights.TabLineDivider = { fg = c.bg_statusline }
        highlights.TabLineDividerSel = { fg = c.blue, bg = c.blue }
        highlights.TabLineDividerVisible = { fg = c.blue }
        highlights.TabLineDividerModifiedSel = { fg = c.warning, bg = c.warning }
      end,
    },
    config = true,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("rose-pine").setup({
        variant = "moon", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        palette = {
          moon = {
            pine = "#a5b4fc",
          },
        },

        highlight_groups = {
          Visual = { bg = "#a5b4fc" },
          -- VertSplit = { fg = "muted", bg = "muted" },
        },
      })

      -- vim.cmd("colorscheme rose-pine-moon")
    end,
  },
  {
    "bluz71/nvim-linefly",
    lazy = true,
    enabled = true,
    event = "VimEnter",
    config = function()
      vim.g.linefly_options = {
        separator_symbol = "◆",
        progress_symbol = "↓",
        active_tab_symbol = "▪",
        git_branch_symbol = "",
        error_symbol = "",
        warning_symbol = "",
        information_symbol = "",
        ellipsis_symbol = "…",
        tabline = false,
        winbar = false,
        with_file_icon = true,
        with_git_branch = true,
        with_git_status = true,
        with_diagnostic_status = true,
        with_session_status = true,
        with_attached_clients = true,
        with_macro_status = true,
        with_search_count = false,
        with_spell_status = false,
        with_indent_status = true,
      }
    end,
  },
}
