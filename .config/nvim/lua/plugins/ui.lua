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
        highlights.TabLineIndexSel = { fg = c.bg, bg = c.blue, bold = true }
        highlights.MiniStatuslineDevinfo = { fg = "#c8d3f5", bg = "#292C42" }
        highlights.MiniStatuslineFilename = { fg = "#c8d3f5" }
        highlights.MiniStatuslineFileinfo = { fg = "#c8d3f5", bg = "#292C42" }
        highlights.MiniTablineCurrent = { fg = "#c8d3f5", bg = "#292C42" }
        highlights.MiniTablineTabpagesection = { fg = "#c8d3f5", bg = "#292C42" }
        highlights.MiniTablineModifiedCurrent = { fg = "#ffc777", bg = "#292C42" }
        highlights.LeapMatch = { fg = "#c3e88d", bg = "#292C42" }
        highlights.LeapLabel = { fg = "#292C42", bg = "#c3e88d" }
        highlights.LeapBackdrop = { fg = "none", bg = "none" }
        highlights.LeapLabelDimmed = { fg = "#4fd6be", bg = "#292C42" }
      end,
    },
    config = true,
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
