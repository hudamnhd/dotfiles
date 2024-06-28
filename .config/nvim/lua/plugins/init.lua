vim.g.asyncrun_exit = "!pkill eslint_d"
-- vim.g.asyncrun_exit = "echo 'Success'"
-- vim.g.user_emmet_leader_key = "<C-Z>"
-- vim.g.user_emmet_mode = "i"

return {
  {
    "kana/vim-g",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        let g:g_vc_split_modifier = 'vertical'
        " open file
        nnoremap df :G args 
      ]])
    end,
  },
  {
    "brenton-leighton/multiple-cursors.nvim",
    tag = "v0.9",
    opts = {}, -- Implicitly calls setup()
    keys = {
      {
        "<a-n>",
        "<Cmd>MultipleCursorsAddDown<CR>",
        mode = { "n", "x" },
        desc = "Add cursor and move down",
      },
      {
        "<a-p>",
        "<Cmd>MultipleCursorsAddUp<CR>",
        mode = { "n", "x" },
        desc = "Add cursor and move up",
      },

      {
        "<leader>va",
        "<Cmd>MultipleCursorsAddMatches<CR>",
        mode = { "n", "x" },
        desc = "Add cursors to cword",
      },
      {
        "<leader>vA",
        "<Cmd>MultipleCursorsAddMatchesV<CR>",
        mode = { "n", "x" },
        desc = "Add cursors to cword in previous area",
      },

      {
        "<leader>vd",
        "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
        mode = { "n", "x" },
        desc = "Add cursor and jump to next cword",
      },
      {
        "<leader>vD",
        "<Cmd>MultipleCursorsJumpNextMatch<CR>",
        mode = { "n", "x" },
        desc = "Jump to next cword",
      },

      {
        "<leader>vv",
        "<Cmd>MultipleCursorsLock<CR>",
        mode = { "n", "x" },
        desc = "Lock virtual cursors",
      },
    },
  },
  {
    "cohama/agit.vim",
    cmd = { "Agit", "AgitFile" },
    config = function() end,
  },
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = function()
      require("live-server").setup()
    end,
  },
  -- install with yarn or npm
  {
    "nvimdev/indentmini.nvim",
    event = { "BufReadPost" },
    config = function()
      require("indentmini").setup() -- use default config
      vim.cmd.highlight("IndentLine guifg=#45475a")
      vim.cmd.highlight("IndentLineCurrent guifg=#9CABCA")
    end,
  },
  {
    "haya14busa/vim-edgemotion",
    event = { "BufReadPost" },
    config = function()
      vim.cmd([[
       map <C-J> <Plug>(edgemotion-j)
       map <C-K> <Plug>(edgemotion-k)
       ]])
    end,
  },
  {
    "hudamnhd/search-replace.nvim",
    event = { "BufReadPost" },
    config = function()
      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "g",
        -- default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
      -- vim.o.inccommand = "split"
      local opts = {}

      local get_selected_lines_count = function()
        local start_line = vim.fn.getpos("v")[2]
        local end_line = vim.fn.getpos(".")[2]

        return math.abs(end_line - start_line) + 1
      end

      local call_visual_command = function()
        local current_mode = vim.fn.mode()
        local number_of_lines_selected_in_visual_mode = get_selected_lines_count()

        if
          (current_mode == "V" or current_mode == "<C-V>")
          and number_of_lines_selected_in_visual_mode == 1
        then
          vim.cmd("SearchReplaceWithinVisualSelectionCWord")
        elseif current_mode == "V" or current_mode == "<C-V>" then
          vim.cmd("SearchReplaceWithinVisualSelection")
        else
          vim.cmd("SearchReplaceSingleBufferVisualSelection")
        end
      end

      vim.keymap.set("x", "<C-F>", call_visual_command, opts)
      vim.keymap.set("n", "<C-F>", [[<CMD>SearchReplaceSingleBufferCWord<CR>]])
    end,
  },
  {
    "thinca/vim-partedit",
    keys = { { "<C-e>", ":Partedit -opener vnew -filetype vim -prefix '>'<CR>", mode = { "x" } } },
  },
  {
    "kshenoy/vim-signature",
    event = { "VimEnter" },
    config = function()
      vim.cmd([[ highlight! link SignatureMarkText WarningMsg ]])
    end,
  },
  { "wellle/targets.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim", event = "VeryLazy" },
  { "thinca/vim-quickmemo", event = "VimEnter" },
  { "nvim-lua/plenary.nvim" },
}
