--------------------------------------------------------------------------------
--- Plugin Setup
--------------------------------------------------------------------------------
local Plugin = {}

-- Best plugin by Echasnovski that provides many modules
-- https://github.com/echasnovski/mini.nvim
function Plugin.core()
  local ok, Deps = pcall(require, 'mini.deps')
  if not ok then return end

  Deps.setup()

  Deps.add({ name = 'mini.nvim', checkout = 'HEAD' })

  Plugin.setup({
    mode = 'config',
    plugins = require('config.plugin.mini'),
  })

  Plugin.setup({
    mode = 'plugin',
    plugins = require('config.plugin.spec'),
  })
end

-- load all custom plugin from "lua/config/plugin/custom"
local custom_path = 'config/plugin/custom'
local custom_dir = vim.fs.normalize(vim.fn.stdpath('config') .. '/lua/' .. custom_path)

function Plugin.custom()
  for name, type in vim.fs.dir(custom_dir) do
    if type == 'file' then
      local mod_name = name:match('(.+)%.lua$')
      if mod_name then require(custom_path:gsub('/', '.') .. '.' .. mod_name) end
    end
  end
end

function Plugin.bootstrap()
  local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
  if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/echasnovski/mini.nvim',
      mini_path,
    })
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
  end
end

--- setup plugins or configs.
--- @param opts table { plugins, mode='plugin'|'config', dryrun, verbose }
function Plugin.setup(opts)
  opts = opts or {}
  local plugins = opts.plugins or {}
  local mode = opts.mode or 'plugin'
  local dryrun = opts.dryrun or false
  local verbose = opts.verbose or false

  local ok, Deps = pcall(require, 'mini.deps')
  if not ok then return end

  local now_setups, later_setups = {}, {}

  -- Helper: setup plugin
  --- @param module string
  --- @param opts? table
  local function setup_plugin(module, opts)
    if dryrun then
      print('[DRYRUN] Simulating setup for module: ' .. module)
      return
    end
    if verbose then print('[VERBOSE] Setup module: ' .. module) end
    local ok, plugin = pcall(require, module)
    if ok and plugin and type(plugin.setup) == 'function' then
      plugin.setup(opts or {})
    else
      vim.notify('Failed to load or setup module: ' .. module, vim.log.levels.WARN)
    end
  end

  --- @param entry table
  local function run_config(entry)
    if type(entry.config) == 'function' then
      if dryrun then
        print('[DRYRUN] Simulating run custom config function for: ' .. (entry.module or 'unknown'))
      else
        if verbose then print('[VERBOSE] Running custom config function for: ' .. (entry.module or 'unknown')) end
        entry.config()
      end
    end
  end

  for _, entry in ipairs(plugins) do
    local lazy = entry.lazy ~= false -- default true
    local runner = (mode == 'config')
        and function()
          if entry.enable ~= false then
            if type(entry.opts) == 'table' or (entry.config == true or type(entry.config) == 'boolean') then
              setup_plugin(entry.module, entry.opts)
            end
            run_config(entry)
          end
        end
      or function()
        entry.module = entry.name or entry.source
        local spec = vim.deepcopy(entry)
        spec.lazy = nil

        -- See :help Deps.add()
        if entry.enable ~= false then
          Deps.add(spec)
          run_config(entry)
        end
      end

    table.insert(lazy and later_setups or now_setups, runner)
  end

  for _, fn in ipairs(now_setups) do
    -- See :help Deps.now()
    Deps.now(fn)
  end
  for _, fn in ipairs(later_setups) do
    -- See :help Deps.later()
    Deps.later(fn)
  end
end

-- Run
Plugin.bootstrap()
Plugin.core()
Plugin.custom()

return Plugin
