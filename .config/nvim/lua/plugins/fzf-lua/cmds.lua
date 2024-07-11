local M = {}

local relative_cursor = {
  relative = "cursor",
  row = 1.01,
  col = 0,
  height = 0.30,
  width = 0.30,
}

function M.complete_path()
  require("fzf-lua").complete_path({
    cmd = "fdfind --type d --type f --exclude .git",
    file_icons = false,
  })
end

function M.oldfiles()
  vim.cmd("rshada!")
  require("fzf-lua").oldfiles({
    cwd = vim.uv.cwd(),
    cwd_header = true,
    cwd_only = true,
  })
end

function M.grep_curbuf()
  require("fzf-lua").grep_curbuf({ query = vim.fn.expand("<cword>") })
end

function M.spell_suggest()
  local opts_spell = {
    prompt = "Spell> ",
    winopts = relative_cursor,
  }
  require("fzf-lua").spell_suggest(opts_spell)
end

function M.get_all_words()
  local line_count = vim.api.nvim_buf_line_count(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, line_count, false)
  local content = table.concat(lines, "\n")
  local words = {}
  local unique_words = {}
  for word in string.gmatch(content, "[%w_-]+") do
    if not unique_words[word] then
      unique_words[word] = true
      table.insert(words, word)
    end
  end

  table.sort(words)
  return words
end

function M.T(pattern)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(pattern, true, false, true), "n", true)
end

function M.list_all_words_with_fzf()
  local words = M.get_all_words()
  require("fzf-lua").fzf_exec(words, {
    -- complete = true,
    header = "ctrl-b for visual , cr for normal , ctrl-s for subtitute",
    actions = {
      ["ctrl-s"] = function(selected, o)
        local query = selected[1] or o.last_query
        local pattern = ":%s/<C-R><C-W>/" .. query .. "/gc<left><left><left>"
        M.T(pattern)
      end,
      ["ctrl-b"] = function(selected, o)
        local query = selected[1] or o.last_query
        local pattern = ":'<,'>s/<C-R><C-W>/" .. query .. "/gc<left><left><left>"
        M.T(pattern)
      end,
      ["default"] = function(selected, o)
        local query = selected[1] or o.last_query
        local pattern = "/" .. query .. "<cr>"
        M.T(pattern)
      end,
    },
    winopts = relative_cursor,
  })
end

local api, fn, uv = vim.api, vim.fn, vim.loop

---Most recently used files
function M.mru()
  local current
  if api.nvim_buf_get_option(0, "buftype") == "" then
    current = uv.fs_realpath(api.nvim_buf_get_name(0))
  end

  local files = {}
  for _, file in ipairs(require("mru").get()) do
    if file ~= current then
      files[#files + 1] = fn.fnamemodify(file, ":~")
    end
  end

  if #files > 0 then
    require("fzf-lua").fzf_exec(files, {
      actions = {
        ["default"] = require("fzf-lua").actions.file_edit,
      },
      fzf_opts = {
        ["--multi"] = "",
      },
      prompt = "MRU> ",
      winopts = { height = 0.4, width = 0.5 },
    })
  else
    print("No recently used files", "WarningMsg")
  end
end

vim.api.nvim_create_user_command("MRU",  M.mru, {})

-- stylua: ignore start
vim.keymap.set('n', ',',          M.list_all_words_with_fzf,        { desc = '󰕮  Search' })
vim.keymap.set("n", "z=",         M.spell_suggest,                  { desc = "spell_suggest" })
vim.keymap.set("i", "<C-X><C-F>", M.complete_path,                  { desc = "Fuzzy complete path" })
vim.keymap.set("n", "yu",         require("fzf-lua").registers,     { desc = "registers" })
vim.keymap.set("i", "<C-L>",      require("fzf-lua").complete_line, { desc = "Fuzzy complete line" })
-- stylua: ignore end

return M
