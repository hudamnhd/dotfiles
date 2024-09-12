return {
  "jake-stewart/multicursor.nvim",
  event = "BufReadPost",
    -- stylua: ignore start
    config = function()
      local mc = require("multicursor-nvim")
      local bind = require("keymaps").bind

      mc.setup()

      -- use MultiCursorCursor and MultiCursorVisual to customize
      -- additional cursors appearance
      vim.cmd.hi("link", "MultiCursorCursor", "Cursor")
      vim.cmd.hi("link", "MultiCursorVisual", "Visual")

      -- add cursors above/below the main cursor
      bind({ "n", "v" }, "<a-up>", function() mc.addCursor("k") end)
      bind({ "n", "v" }, "<a-down>", function() mc.addCursor("j") end)
      -- add a cursor and jump to the next word under cursor
      bind({ "n", "v" }, "<a-n>", function() mc.addCursor("*") end)
      -- jump to the next word under cursor but do not add a cursor
      bind({ "n", "v" }, "<a-s-n>", function() mc.skipCursor("*") end)

      -- rotate the main cursor

      -- local bmui = require("buffer_manager.ui")
      local function handle_cursors(key)
        if mc.hasCursors() then
          if key == "<esc>" then
            mc.clearCursors()
          elseif key == "<tab>" then
            mc.nextCursor()
          elseif key == "<bs>" then
            mc.prevCursor()
          elseif key == "<a-x>" then
            mc.deleteCursor()
          end
        else
          if key == "<esc>" then
            vim.cmd("nohlsearch|diffupdate|echo")
          elseif key == '<bs>' then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
          elseif key == '<tab>' then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
          elseif key == "<a-x>" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
          end
        end
      end

      bind("n", "<esc>", function() handle_cursors("<esc>") end)
      bind("n", "<tab>", function() handle_cursors("<tab>") end)
      bind("n", "<bs>",  function() handle_cursors("<bs>") end)
      bind("n", "<a-x>", function() handle_cursors("<a-x>") end)
      -- add and remove cursors with control + left click
      bind("n", "<c-leftmouse>", mc.handleMouse)
    end,
  -- stylua: ignore end
}
