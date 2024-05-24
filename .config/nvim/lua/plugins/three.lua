local uv = vim.uv or vim.loop
local is_windows = uv.os_uname().version:match("Windows")
local sep = is_windows and "\\" or "/"

return {
  {
    "stevearc/three.nvim",
    event = "VeryLazy",
    commit = "713e20011f670e1209d51bdce46c740a774fa42c",
    opts = {
      projects = {
        allowlist = {
          vim.fn.stdpath("data") .. "/lazy",
          vim.fs.normalize("~/dotfiles"),
        },
        extra_allowlist = {},
        filter_dir = function(dir)
          local dotgit = dir .. sep .. ".git"
          if vim.fn.isdirectory(dotgit) == 1 or vim.fn.filereadable(dotgit) == 1 then
            return true
          end
          -- If this is the child directory of a .git directory, ignore
          return vim.fn.finddir(".git", dir .. ";") == ""
        end,
      },
    },
    config = function(_, opts)
      vim.list_extend(opts.projects.allowlist, vim.tbl_keys(opts.projects.extra_allowlist))
      local three = require("three")
      three.setup(opts)
-- stylua: ignore start
      vim.keymap.set("n", "w",     three.next,                { desc = "Next buffer" })
      vim.keymap.set("n", "q",     three.prev,                { desc = "Previous buffer" })
      vim.keymap.set("n", "<S-w>", three.move_right,          { desc = "Move buffer right" })
      vim.keymap.set("n", "<S-q>", three.move_left,           { desc = "Move buffer left" })
      vim.keymap.set("n", "<c-y>", three.wrap(three.next_tab, { wrap = true }, { desc = "[G]oto next [T]ab" }))
      vim.keymap.set("n", "<c-t>", three.wrap(three.prev_tab, { wrap = true }, { desc = "[G]oto prev [T]ab" }))
      vim.keymap.set("n", "b",     "<C-6>",                   { desc = "[G]oto prev [T]ab" })

      for i = 1, 20 do
        vim.keymap.set("n", i .. "b", three.wrap(three.jump_to, i))
      end

      vim.keymap.set("n", "<leader>`",  three.wrap(three.next,    { delta = 100 }))
      vim.keymap.set("n", "<leader>bh", three.hide_buffer,        { desc = "[B]uffer [H]ide" })
      vim.keymap.set("n", "<leader>bm", function()
        vim.ui.input({ prompt = "Move buffer to:" }, function(idx)
          idx = idx and tonumber(idx)
          if idx then
            three.move_buffer(idx)
          end
        end)
      end, { desc = "[B]uffer [M]ove" })

      vim.keymap.set("n", "<leader>wc", "<cmd>tabclose<CR>",                 { desc = "Close tab" })
      vim.keymap.set("n", "<leader>wb", three.clone_tab,                     { desc = "Clone tab" })
      vim.keymap.set("n", "<leader>wn", "<cmd>tabnew | set nobuflisted<CR>", { desc = "New tab" })
      vim.keymap.set("n", "<leader>w`", three.toggle_scope_by_dir,           { desc = "Toggle tab scoping by directory" })
      vim.keymap.set("n", "<leader>ww",  '<C-W>|')
      vim.keymap.set("n", "<leader>we",  '<C-W>=')
      -- stylua: ignore end

       vim.keymap.set("n", "<c-p>", three.open_project, { desc = "[F]ind [P]roject" })
      vim.api.nvim_create_user_command("ProjectDelete", function() three.remove_project()
      end, {})
    end,
  },
  {
    "numToStr/Buffers.nvim",
    event = "BufRead",
    config = function()
      vim.keymap.set("n", "<a-c>", "<C-W>c")
      vim.keymap.set("n", "<leader><a-c>", '<CMD>lua require("Buffers").only()<CR>') -- BufCloseAllButCurrent
      vim.keymap.set("n", "<a-q>", '<CMD>lua require("Buffers").delete()<CR>')
      vim.keymap.set("n", "<leader><a-q>", '<CMD>lua require("Buffers").clear()<CR>') -- BufCloseAll
    end,
  },
}
