---@class snacks.Config
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true, layout = {
      preview = "main",
      preset = "ivy",
    } },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  -- stylua: ignore start
  keys = {
    -- Top Pickers & Explorer
    { "ss", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<space>e", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<space>s", function() Snacks.picker() end, desc = "Snacks" },
    -- Other
    { "<space>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<space>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<space>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<space>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<space>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<space>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<space>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<space>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<space>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<space>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<space>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<space>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<space>uL")
        Snacks.toggle.diagnostics():map("<space>ud")
        Snacks.toggle.line_number():map("<space>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<space>uc")
        Snacks.toggle.treesitter():map("<space>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<space>ub")
        Snacks.toggle.inlay_hints():map("<space>uh")
        Snacks.toggle.indent():map("<space>ug")
        Snacks.toggle.dim():map("<space>uD")
      end,
    })
  end,
  -- stylua: ignore end
}
