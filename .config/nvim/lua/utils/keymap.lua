local M = {}

M.bind = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.feedkeys = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

--- Wrapper keymap
---@param keymaps table
---@param keymap_opts table?
---@return table
M.map = function(keymaps, keymap_opts)
  keymap_opts = keymap_opts or {}
  for modes, maps in pairs(keymaps) do
    for _, m in pairs(maps) do
      local opts = vim.tbl_extend("force", keymap_opts, m[3] or {})
      M.bind(modes, m[1], m[2], opts)
    end
  end
end

return M
