return {
  {
    "numToStr/FTerm.nvim",
    keys = { "<leader>r", "<leader>e", "se", "<c-g>", "<F1>", "<F2>", "<F3>" },
    config = function()
      require("FTerm").setup({
        border = "rounded",
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      })
      -- Example keybindings
      vim.keymap.set("n", "<F1>", "<Nop>")
      vim.keymap.set("n", "<F1>", '<CMD>lua require("FTerm").toggle()<CR>')
      vim.keymap.set("t", "<F1>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

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

      -- Code Runner - execute commands in a floating terminal
      local runners = { lua = "lua", javascript = "node" }

      vim.keymap.set("n", "se", function()
        local buf = vim.api.nvim_buf_get_name(0)
        local ftype = vim.filetype.match({ filename = buf })
        local exec = runners[ftype]
        if exec ~= nil then
          require("FTerm").scratch({ cmd = { exec, buf } })
        end
      end)

      local commands = {
        "yarn dev",
        "yarn start",
        "php artisan serve",
        -- tambahkan perintah lain di sini
      }
      local commandsEx = {
        "yarn build",
        -- tambahkan perintah lain di sini
      }

      local function executeCommand(command, isScratch)
        local FTerm = require("FTerm")
        if isScratch then
          FTerm.scratch({ cmd = command })
        else
          FTerm.run({ command })
        end
      end

      local function executeFTerm(isScratch)
        local prompt = "Pilih nomor dari daftar:\n"

        if isScratch then
          for i, cmd in ipairs(commandsEx) do
            prompt = prompt .. string.format("%d. %s\n", i, cmd)
          end
        else
          for i, cmd in ipairs(commands) do
            prompt = prompt .. string.format("%d. %s\n", i, cmd)
          end
        end

        local input = vim.fn.input(prompt .. "Cmd: ")
        local idx = tonumber(input)
        if idx and idx > 0 and idx <= #commands then
          executeCommand(commands[idx], isScratch)
        elseif input ~= "" then
          executeCommand(input, isScratch)
        else
          print("Canceled")
        end
      end

      vim.keymap.set("n", "<leader>r", function()
        pcall(function()
          executeFTerm(false)
        end)
      end, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>e", function()
        pcall(function()
          executeFTerm(true)
        end)
      end, { noremap = true, silent = true })

      local yarndev = fterm:new({
        ft = "fterm_yarn", -- You can also override the default filetype, if you want
        -- cmd = "yarn dev",
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
        -- cmd = "php artisan serve",
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
    end,
  },
}
