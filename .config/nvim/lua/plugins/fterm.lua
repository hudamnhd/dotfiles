return {
  "numToStr/FTerm.nvim",
  keys = { "<c-g>", "<F1>", "<F2>", "<F3>" },
  cmd = { "YarnBuild" },
  config = function()
    require("FTerm").setup({
      border = "rounded",
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
    })
    local fterm = require("FTerm")

    local gitui = fterm:new({
      ft = "fterm_gitui", -- You can also override the default filetype, if you want
      cmd = "gitui",
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })
    -- Use this to toggle gitui in a floating terminal
    vim.keymap.set("n", "<c-g>", function()
      gitui:toggle()
    end)
    vim.keymap.set("t", "<c-g>", function()
      gitui:toggle()
    end)

    local yarndev = fterm:new({
      ft = "fterm_yarn", -- You can also override the default filetype, if you want
      cmd = "yarn dev",
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })
    -- Use this to toggle yarndev in a floating terminal
    vim.keymap.set("n", "<F2>", function()
      yarndev:toggle()
    end)
    vim.keymap.set("t", "<F2>", function()
      yarndev:toggle()
    end)

    local phpserve = fterm:new({
      ft = "fterm_artisanserve", -- You can also override the default filetype, if you want
      cmd = "php artisan serve",
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })
    -- Use this to toggle phpserve in a floating terminal
    vim.keymap.set("n", "<F3>", function()
      phpserve:toggle()
    end)
    vim.keymap.set("t", "<F3>", function()
      phpserve:toggle()
    end)
    -- Example keybindings
    vim.keymap.set("n", "<F1>", "<Nop>")
    vim.keymap.set("n", "<F1>", '<CMD>lua require("FTerm").toggle()<CR>')
    vim.keymap.set("t", "<F1>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

    -- Scratch terminals are awesome because you can do this
    vim.api.nvim_create_user_command("YarnBuild", function()
      require("FTerm").scratch({ cmd = { "yarn", "build" } })
    end, { bang = true })
    -- Code Runner - execute commands in a floating terminal
    local runners = { lua = "lua", javascript = "node" }

    vim.keymap.set("n", "<leader>e", function()
      local buf = vim.api.nvim_buf_get_name(0)
      local ftype = vim.filetype.match({ filename = buf })
      local exec = runners[ftype]
      if exec ~= nil then
        require("FTerm").scratch({ cmd = { exec, buf } })
      end
    end)
    -- vim.keymap.set("n", "<leader>l", function() require('FTerm').scratch({ cmd = {'npm', 'run', 'lint'} }) end )
  end,
}
