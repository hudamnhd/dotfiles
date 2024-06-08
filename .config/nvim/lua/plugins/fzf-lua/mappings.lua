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

-- stylua: ignore start
mfzf("n", "<leader>.", "builtin", { desc = "builtin commands" })
mfzf("n", "<leader><F1>", "man_pages", { desc = "man pages" })

mfzf("n", "s;", "commands", { desc = "commands" })
mfzf("n", "sc", "command_history", { desc = "command history" })
mfzf("n", "sx", "search_history", { desc = "search history" })

mfzf("n", "sqe", "diagnostics_document", { desc = "document diagnostics [LSP]" })
mfzf("n", "sqd", "diagnostics_workspace", { desc = "workspace diagnostics [LSP]" })
mfzf("n", "sqn", "files", {
  desc = "Note files",
  prompt = "Notes❯ ",
  cwd = "~/vimwiki"
})
map("i",  "<C-x><C-f>", function() require("fzf-lua").complete_path({ file_icons = false }) end, { silent = true, desc = "Fuzzy complete path" })
map("i",  "<C-x><C-l>", function() require("fzf-lua").complete_line() end, { silent = true, desc = "Fuzzy complete line" })

map("n",  "so", "<CMD>MRU<CR>", { desc = "file history (MRU)" })
mfzf("n", "s0", "oldfiles", function() return { desc = "file history (cwd)", cwd = vim.loop.cwd(), cwd_header = true, cwd_only = true } end)

mfzf("n", "sp", "files", { desc = "find files"})
mfzf("n", "sap", "files", { cwd = "%:h" })
mfzf("n", "sb", "buffers", { desc = "Fzf buffers" })

mfzf("v", "sk", "grep_visual", { desc = "grep visual selection" })
mfzf("n", "sk", "grep_cword", { desc = "grep <word> (project)" })

-- git
mfzf("n", "saa", "git_status", { desc = "git status" })
mfzf("n", "saB", "git_branches", { desc = "git branches" })
mfzf("n", "sac", "git_commits", { desc = "git commits (project)" })
mfzf("n", "sab", "git_bcommits", { desc = "git commits (buffer)" })

mfzf("n", "sl", "grep_curbuf", function() return { desc = "grep <word> (buffer)", prompt = "Buffer❯ ", search = vim.fn.expand("<cword>") } end)
mfzf("v", "sl", "grep_curbuf", function() return { desc = "grep <WORD> (buffer)", prompt = "Buffer❯ ", search = require("utils.other").get_visual_selection(true) } end)

mfzf("n", "zf", "files", function() return { desc = "grep <word> (buffer)", prompt = "Files❯ ", query = vim.fn.expand("<cword>") } end)
mfzf("v", "zf", "files", function() return { desc = "grep files", prompt = "Files❯ ", query = require("utils.other").get_visual_selection(true) } end)

mfzf("n", "sg", "grep", { desc = "grep string (prompt)" })
mfzf("n", "sag", "grep", { desc = "grep string resume", resume = true })

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

local function remove_ansi_codes(text)
  return text:gsub("\27%[[%d;]*[%d]*m", "")
end

local function files(dir, opts)
  vim.validate({
    dir = { dir, "string", true },
    opts = { opts, "table", true },
  })

  dir = assert(dir or vim.loop.cwd())
  dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":p") -- ensure trailing path separator

  local icons = {}
  local entries = {}

  -- Get the list of files and directories using fdfind

  -- local fd_command = 'fdfind . "' .. dir .. '" --color=never  --hidden --exclude .git'
  local fd_command = 'fdfind . "' .. dir .. '" --color=never  --hidden --exclude .git'
  -- local fd_command = 'fdfind . "' .. dir .. '" --type d --type f --hidden --exclude .git'
  local handle = io.popen(fd_command)
  local result = handle:read("*a")
  local result_parse = handle:read("*a")
  handle:close()

  -- Debug: Print the result to see the output from fdfind
  for entry in result:gmatch("[^\r\n]+") do
    local full_path = vim.fn.fnamemodify(entry, ":p")
    local name = vim.fn.fnamemodify(entry, ":t")
    local stat = vim.loop.fs_stat(full_path)

    if stat then
      if stat.type == "directory" then
        local directory_name = vim.fn.fnamemodify(full_path, ":p:h:t")
        entries[" " .. directory_name .. " - " .. full_path] = {
          type = "directory",
          path = full_path,
          hl = "DirectoryLine",
        }
      else
        local icon, hl = require("nvim-web-devicons").get_icon(
          name,
          vim.fn.fnamemodify(name, ":e"),
          { default = true }
        )

        icons[icon] = hl
        entries[icon .. " " .. name] = {
          type = "file",
          path = full_path,
        }
      end
    else
      print("Failed to get stat for:", full_path)
    end
  end

  -- "goto parent" entry only if we're not at root level
  if dir ~= "/" then
    entries[" .."] = {
      type = "directory",
      path = vim.fn.fnamemodify(dir, ":p:h:h"),
    }
  end

  local display_entries = vim.tbl_keys(entries)
  -- print(vim.inspect(display_entries))
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
          vim.api.nvim_command("edit " .. element.path)
        end
      end,
      -- quickly jump to the home directory
      -- ["ctrl-h"] = {
      --   function()
      --     files("~", opts)
      --   end,
      --   fzf.actions.resume,
      -- },
      ["ctrl-h"] = {
        function()
          local parent_dir = vim.fn.fnamemodify(dir, ":p:h:h")
          if parent_dir ~= "/" then
            files(parent_dir, opts)
          else
            files("~", opts) -- Kembali ke home directory jika sudah di root
          end
        end,
        fzf.actions.resume,
      },
      -- create a new directory
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

-- local mappings = {
--   { "<leader>f", file_explorer, "file explorer (cwd)" },
--   { "sj", function() file_explorer("%:h") end, "file explorer (cwd)", },
-- }
--
-- for _, m in ipairs(mappings) do
--   local lhs, rhs, desc = unpack(m)
--   vim.keymap.set("n", lhs, rhs, { desc = desc })
-- end
