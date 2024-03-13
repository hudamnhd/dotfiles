local fzf = require("fzf-lua")

local mfzf = function(mode, key, f, options, buffer)
  local desc = nil
  if type(options) == "table" then
    desc = options.desc
    options.desc = nil
  elseif type(options) == "function" then
    desc = options().desc
  end

  local rhs = function()
    local fzf_lua = require("fzf-lua")
    local custom = require("plugins.fzf-lua.cmds")
    -- use deepcopy so options ref isn't saved in the mapping
    -- as this can create weird issues, for example, `lgrep_curbuf`
    -- saving the filename in between executions
    if custom[f] then
      custom[f](options and vim.deepcopy(options) or {})
    else
      fzf_lua[f](options and vim.deepcopy(options) or {})
    end
  end

  local map_options = {
    silent = true,
    buffer = buffer,
    desc = desc or string.format("FzfLua %s", f),
  }

  vim.keymap.set(mode, key, rhs, map_options)
end

local map = vim.keymap.set

local function files(dir, opts)
  vim.validate({
    dir = { dir, "string", true },
    opts = { opts, "table", true },
  })

  dir =  assert(dir or vim.loop.cwd())
  dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":p") -- ensure trailing path separator

  local icons = {}
  local entries = {}

  -- "goto parent" entry only if we're not at root level
  if dir ~= "/" then
    entries[" .."] = {
      type = "directory",
      path = vim.fn.fnamemodify(dir, ":p:h:h"),
    }
  end

  for name, type in vim.fs.dir(dir) do
    if type == "directory" then
      entries[" " .. name] = {
        type = type,
        path = dir .. name,
      }
    else
      local icon, hl = require("nvim-web-devicons").get_icon(
        name,
        vim.fn.fnamemodify(name, ":e"),
        { default = true }
      )

      icons[icon] = hl
      entries[icon .. " " .. name] = {
        type = type,
        path = dir .. name,
      }
    end
  end

  local display_entries = vim.tbl_keys(entries)
  table.sort(display_entries)

  -- "clone" the given options table to prevent modifying the original in case of recursive fn calls
  local options = vim.tbl_extend("force", {}, opts)
  if options.actions then
    -- create the custom actions to make them easier "mergeable" with the defaults
    options.actions = options.actions(dir, entries)
  end
  local defaults_opts = {
    prompt = vim.fn.fnamemodify(dir, ":~") .. "> ",
    actions = {
      ["default"] = function(selected)
        local element = entries[selected[1]]

        if not element then
          return
        end

        if element.type == "directory" then
          files(element.path, opts)
        else
          vim.cmd.e(element.path)
        end
      end,
      -- quickly jump the home directory
      ["ctrl-h"] = {
        function()
          files("~", opts)
        end,
        fzf.actions.resume,
      },
    },
  }
  options = assert(vim.tbl_deep_extend("force", defaults_opts, options))

  if type(options.prompt) == "function" then
    options.prompt = options.prompt(dir)
  end

  fzf.fzf_exec(display_entries, {
    prompt = options.prompt,
    actions = options.actions,
    winopts = {
      on_create = function()
        for icon, hl in pairs(icons) do
          vim.fn.matchadd(hl, icon)
        end
      end,
    },
  })
end

local function file_explorer(directory)
  files(directory, {
    actions = function(dir, entries)
      -- a little helper function to avoid repetition
      local edit_file = function(pre_cmd)
        return function(selected)
          local element = entries[selected[1]]

          if pre_cmd then
            vim.cmd(pre_cmd)
          end

          vim.cmd.e(element.path)
        end
      end

      return {
        ["alt-d"] = function()
          require("drex").open_directory_buffer(dir)
        end,
        ["alt-s"] = {
          function()
            fzf.live_grep({
              prompt = 'Search "' .. dir .. '"> ',
              cwd = dir,
            })
          end,
          fzf.actions.resume,
        },
        ["alt-t"] = function()
          local buf = vim.api.nvim_create_buf(true, false)
          vim.api.nvim_set_current_buf(buf)
          vim.fn.termopen(vim.o.shell, { cwd = dir })
        end,
        ["alt-f"] = {
          function()
            fzf.files({
              cwd = dir,
            })
          end,
          fzf.actions.resume,
        },
        ["alt-b"] = {
          function()
            fzf.buffers({
              cwd = dir,
              -- no header lines, make every entry selectable
              fzf_opts = { ["--header-lines"] = false },
            })
          end,
          fzf.actions.resume,
        },
        ["ctrl-v"] = edit_file("vsplit"),
        ["ctrl-s"] = edit_file("split"),
        ["ctrl-t"] = edit_file("tabnew"),
      }
    end,
  })
end

-- stylua: ignore start
map("i",  "<C-x><C-f>", function() require("fzf-lua").complete_path({ file_icons = false }) end, { silent = true, desc = "Fuzzy complete path" })
map("i",  "<C-x><C-l>", function() require("fzf-lua").complete_line() end, { silent = true, desc = "Fuzzy complete line" })

map("n",  "sn", file_explorer)

map("n",  "so", "<CMD>MRU<CR>", { desc = "file history (MRU)" })
mfzf("n", "sO", "oldfiles", function() return { desc = "file history (cwd)", cwd = vim.loop.cwd(), cwd_header = true, cwd_only = true } end)

map("n",  "sP", function() file_explorer("%:h") end)
mfzf("n", "sp", "files", { desc = "find files"})
mfzf("n", "dp", "git_files", { desc = "find git_files"})

mfzf("n", "sb", "buffers", { desc = "Fzf buffers" })
mfzf("n", "sj", "blines", { desc = "Fzf blines" })
mfzf("n", "sJ", "lines", { desc = "Fzf lines" })

mfzf("v", "sk", "grep_visual", { desc = "grep visual selection" })
mfzf("n", "sk", "grep_cword", { desc = "grep <word> (project)" })
mfzf("n", "sK", "grep_cWORD", { desc = "grep <WORD> (project)" }) -- not used

mfzf("n", "sl", "grep_curbuf", function() return { desc = "grep <word> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cword>") } end)
mfzf("v", "sl", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = require("utils.other").get_visual_selection(true) } end)
mfzf("n", "sL", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cWORD>") } end)  -- not used

mfzf("n", "zf", "files", function() return { desc = "grep <word> (buffer)", prompt = "Files❯ ", query = vim.fn.expand("<cword>") } end)
mfzf("v", "zf", "files", function() return { desc = "grep files", prompt = "Files❯ ", query = require("utils.other").get_visual_selection(true) } end)

mfzf("n", "gl", "grep", { desc = "grep string (prompt)" })
mfzf("n", "gL", "grep", { desc = "grep string resume", resume = true })

mfzf("n", '"', "registers", { desc = "registers" })
-- stylua: ignore end

mfzf("n", "z=", "spell_suggest", {
  desc = "spell suggestions",
  prompt = "Spell> ",
  winopts = {
    relative = "cursor",
    row = 1.01,
    col = 0,
    height = 0.30,
    width = 0.30,
  },
})

-- mfzf("n", "sH", "oldfiles", { desc = "file history (all)", cwd = "~", cwd_header = false }) --replace with mru
-- mfzf("n", "sfp", "files", { desc = "plugin files", prompt = "Plugins❯ ", cwd = vim.fn.stdpath("data") .. "/lazy", })
-- mfzf("n", [[<leader>;]], "tmux_buffers", { desc = "tmux paste buffers" })
