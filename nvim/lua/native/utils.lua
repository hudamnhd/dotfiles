local M = {}
-------------------------------------------------------------------------------
-- ( Keymaps Helper ) =========================================================
-------------------------------------------------------------------------------

-- Create a smart keymap wrapper using metatables
local keymap = {}

local function rmv_cmd(str) return str:gsub('<cmd>(.-)<cr>', '%1') end
-- Valid vim modes
local valid_modes = { n = true, i = true, v = true, x = true, s = true, o = true, c = true, t = true }

-- Store mode combinations we've created
local mode_cache = {}

-- Function that performs the actual mapping
local function perform_mapping(modes, lhs, rhs, opts)
  opts = opts or {}
  local mapset = vim.keymap.set

  if type(lhs) == 'table' then
    -- Handle table of mappings
    for key, action in pairs(lhs) do
      mapset(modes, key, action, opts)
    end
  else
    -- Handle single mapping
    mapset(modes, lhs, rhs, opts)
  end

  return keymap -- Return keymap for chaining
end

-- Parse a mode string into an array of mode characters
local function parse_modes(mode_str)
  local modes = {}
  for i = 1, #mode_str do
    local char = mode_str:sub(i, i)
    if valid_modes[char] then table.insert(modes, char) end
  end
  return modes
end

-- Create the metatable that powers the dynamic mode access
local mt = {
  __index = function(_, key)
    -- If this mode combination is already cached, return it
    if mode_cache[key] then return mode_cache[key] end

    -- Check if this is a valid mode string
    local modes = parse_modes(key)
    if #modes > 0 then
      -- Create and cache a function for this mode combination
      local mode_fn = function(lhs, rhs, opts)
        opts = opts or { silent = true }

        local mapset = vim.keymap.set

        if type(lhs) == 'table' then
          opts = rhs or { silent = true }
          -- Handle table of mappings
          for key, action in pairs(lhs) do
            opts = vim.tbl_extend('force', (type(action) == 'string' and { desc = rmv_cmd(action) } or {}), rhs or {})
            mapset(modes, key, action, opts)
          end
        else
          -- Handle single mapping
          mapset(modes, lhs, rhs, opts)
        end

        return keymap -- Return keymap for chaining
      end

      mode_cache[key] = mode_fn
      return mode_fn
    end

    return nil -- Not a valid mode key
  end,

  -- Make the keymap table directly callable
  __call = function(_, modes, lhs, rhs, opts)
    if type(modes) == 'string' then
      -- Convert string to mode list
      return perform_mapping(parse_modes(modes), lhs, rhs, opts)
    else
      -- Assume modes is already a list
      return perform_mapping(modes, lhs, rhs, opts)
    end
  end,
}

M.map = setmetatable(keymap, mt)

-------------------------------------------------------------------------------
-- ( Get visual selection ) ===================================================
-------------------------------------------------------------------------------
-- taken from: https://github.com/ibhagwan/nvim-lua/blob/f772c7b41ac4da6208d8ae233e1c471397833d64/lua/utils.lua#L96
M.get_visual_selection = function(nl_literal)
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' or mode == '' then
    _, csrow, cscol, _ = unpack(vim.fn.getpos('.'))
    _, cerow, cecol, _ = unpack(vim.fn.getpos('v'))
    if mode == 'V' then
      cscol, cecol = 0, 999
    end
  else
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end

  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end

  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end

  local lines = vim.fn.getline(csrow, cerow)
  local n = #lines

  if n <= 0 then return '' end

  if n > 1 then return nil end

  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)

  return table.concat(lines, nl_literal and '\\n' or '\n')
end

-- FIXME: how to handle <>'s, etc.
local escape_characters = '"\\/.*$^~[]'

-- double escaping is required due to interpretation by feedkeys and then search/replace
M.double_escape = function(str) return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters) end

-------------------------------------------------------------------------------
-- Other ======================================================================
-------------------------------------------------------------------------------
M.usercmd = vim.api.nvim_create_user_command
M.autocmd = vim.api.nvim_create_autocmd
M.groupid = vim.api.nvim_create_augroup

---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return nil
M.augroup = function(group, ...)
  local id = M.groupid(group, {})
  for _, a in ipairs({ ... }) do
    a[2].group = id
    M.autocmd(unpack(a))
  end
end

M.safe_for_each = function(list, fn)
  if type(list) == 'table' and #list > 0 then
    for _, v in ipairs(list) do
      fn(v)
    end
  end
end

M.cmd = function(command) return '<cmd>' .. command .. '<cr>' end
M.deep_merge = function(default, override) return vim.tbl_deep_extend('force', {}, default, override) end

M.load_modules = function(config)
  -- Load core modules (autocmds, options, etc)
  for name, enabled in pairs(config.core or {}) do
    if enabled then
      local ok, mod = pcall(require, 'native.core.' .. name)
      if ok and type(mod) == 'table' and mod.setup then mod.setup(config) end
    end
  end

  -- Load extras modules (from extras/*.lua)
  for name, enabled in pairs(config.extras or {}) do
    if enabled then
      local ok, mod = pcall(require, 'native.extras.' .. name)
      if ok and type(mod) == 'table' and mod.setup then mod.setup(config) end
    end
  end
end

M.git_root = function(cwd, noerr)
  local cmd = { 'git', 'rev-parse', '--show-toplevel' }
  if cwd then
    table.insert(cmd, 2, '-C')
    table.insert(cmd, 3, vim.fn.expand(cwd))
  end
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    if not noerr then vim.notify(unpack(output), vim.log.levels.INFO, {}) end
    return nil
  end
  return output[1]
end

return M
