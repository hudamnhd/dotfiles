local uv = vim.uv or vim.loop
local is_windows = uv.os_uname().version:match("Windows")
local sep = is_windows and "\\" or "/"

return {
  {
    "stevearc/three.nvim",
    -- commit = "713e20011f670e1209d51bdce46c740a774fa42c",
    event = "VeryLazy",
    opts = {
      bufferline = {
        events = { "BufReadPost", "BufWinLeave" },
        -- should_display = function(tabpage, bufnr, ts) return vim.bo[bufnr].modified end,
        enabled = true,
        icon = {
          -- Tab left/right dividers
          -- Set to this value for more a more compact look
          dividers = { "▍", "" },
          -- dividers = { " ", "" },
          -- Scroll indicator icons when buffers exceed screen width
          scroll = { "«", "»" },
          -- Divider between pinned buffers and others
          pin_divider = "",
          -- Pinned buffer icon
          pin = "󰐃",
        },
      },
      projects = {
        allowlist = {
          -- vim.fn.stdpath("data") .. "/lazy",
          -- vim.fs.normalize("~/vimwiki"),
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
      -- vim.list_extend(opts.projects.allowlist, vim.tbl_keys(opts.projects.extra_allowlist))
      local three = require("three")
      three.setup(opts)
      -- stylua: ignore start
        vim.keymap.set("n", "L",     three.next,                { desc = "Next buffer" })
        vim.keymap.set("n", "H",     three.prev,                { desc = "Previous buffer" })
        -- vim.keymap.set("n", "<A-L>", three.move_right,          { desc = "Move buffer right" })
        -- vim.keymap.set("n", "<A-H>", three.move_left,           { desc = "Move buffer left" })
        vim.keymap.set("n", "T",     three.wrap(three.next_tab, { wrap = true }, { desc = "[G]oto next [T]ab" }))
        vim.keymap.set("n", "tt",     three.wrap(three.prev_tab, { wrap = true }, { desc = "[G]oto prev [T]ab" }))

      for i = 1, 9 do
        -- vim.keymap.set("n", i .. "b", three.wrap(three.jump_to, i))
        vim.keymap.set("n", "<leader>" .. i, three.wrap(three.jump_to, i))
      end

      for i = 1, 9 do
        vim.keymap.set("n", "m" .. i, three.wrap(three.move_buffer, i))
      end

      -- vim.keymap.set("n", "<leader>`",  three.wrap(three.next,    { delta = 100 }))
      vim.keymap.set("n", "<leader>wh", three.hide_buffer,        { desc = "[B]uffer [H]ide" })

      vim.keymap.set("n", "<leader>wq", "<cmd>tabclose<CR>",                 { desc = "Close tab" })
      vim.keymap.set("n", "<leader>wb", three.clone_tab,                     { desc = "Clone tab" })
      vim.keymap.set("n", "<leader>wn", "<cmd>tabnew | set nobuflisted<CR>", { desc = "New tab" })
      -- stylua: ignore end

      vim.keymap.set("n", "<leader>wc", three.close_buffer, { desc = "[B]uffer [C]lose" })
      vim.keymap.set("n", "<C-Q>", three.smart_close, { desc = "[C]lose window or buffer" })
      -- vim.keymap.set("n", "<leader>q", '<CMD>bdelete"<CR>') -- BufCloseAllButCurrent
      -- vim.keymap.set("n", "<leader>Q", '<CMD>%bdelete|edit #|normal `"<CR>') -- BufCloseAllButCurrent

      vim.keymap.set("n", "tw", three.open_project, { desc = "[F]ind [P]roject" })
      vim.api.nvim_create_user_command("ProjectDelete", function()
        three.remove_project()
      end, {})
      vim.api.nvim_create_user_command("ProjectAdd", function()
        local cwd = vim.loop.cwd()
        local project_path = vim.fn.fnamemodify(path, ":p:h")
        three.add_project(project_path)
        print("Adding project at path: " .. project_path)
      end, {})
    end,
  },
}
