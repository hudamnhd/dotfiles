local M = {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
}

function M.config()

-- stylua: ignore start
  require("plugins.fzf-lua.setup")
  require("plugins.fzf-lua.cmds")
  require("plugins.fzf-lua.fzf")
  -- register fzf-lua as vim.ui.select interface
  require("fzf-lua").register_ui_select(function(_, items)
    local min_h, max_h = 0.15, 0.70
    local h = (#items + 4) / vim.o.lines
    if h < min_h then
      h = min_h
    elseif h > max_h then
      h = max_h
    end
    return { winopts = { height = h, width = 0.60, row = 0.40 } }
  end)
end

return M
