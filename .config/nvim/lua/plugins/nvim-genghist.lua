return { -- convenience file operations
  "chrisgrieser/nvim-genghis",
  dependencies = {
    "stevearc/dressing.nvim",
    -- "hrsh7th/nvim-cmp",
    -- "hrsh7th/cmp-omni",
  },
  init = function()
    vim.g.genghis_disable_commands = true
    -- vim.keymap.set("n", "sf", "<NOP>")
    -- required setup for cmp, somewhere after your main cmp-config

    -- Fungsi untuk membuat perintah Vim
    local function create_command(name, cmd, desc)
      vim.api.nvim_create_user_command(name, cmd, { desc = desc })
    end

    -- Definisikan semua perintah
    -- stylua: ignore start
    create_command("CopyFilepath", function() require("genghis").copyFilepath() end, " Copy path")
    create_command("CopyRelativePath", function() require("genghis").copyRelativePath() end, " Copy relative path")
    create_command("CopyFilename", function() require("genghis").copyFilename() end, " Copy filename")
    create_command("RenameFile", function() require("genghis").renameFile() end, " Rename file")
    create_command("MoveFile", function() require("genghis").moveToFolderInCwd() end, " Move file")
    create_command("MoveAndRenameFile", function() require("genghis").moveAndRenameFile() end, " Move file and rename")
    create_command("Chmodx", function() require("genghis").chmodx() end, " chmod +x")
    create_command("DuplicateFile", function() require("genghis").duplicateFile() end, " Duplicate file")
    create_command("TrashFile", function() require("genghis").trashFile({ trashCmd = "trash" }) end, " Move file to trash")
    create_command("CreateNewFile", function() require("genghis").createNewFile() end, " Create new file")
    create_command("MoveSelectionToNewFile", function() require("genghis").moveSelectionToNewFile() end, " Selection to new file")
    -- stylua: ignore end
    -- Untuk perintah dengan mode visual
    vim.api.nvim_create_user_command("MoveSelectionToNewFile", function()
      require("genghis").moveSelectionToNewFile()
    end, { desc = " Selection to new file", range = true })
  end,
  -- keys = {
  -- 	-- stylua: ignore start
  -- 	{"sf1", function() require("genghis").copyFilepath() end,                  desc = " Copy path" }, -- /home/huda/dotfiles/.config/nvim/lua/plugins/init.lua
  -- 	{"sf2", function() require("genghis").copyRelativePath() end,              desc = " Copy relative path" }, -- lua/plugins/init.lua
  -- 	{"sf3", function() require("genghis").copyFilename() end,                  desc = " Copy filename" }, -- init.lua
  -- 	{"sfr", function() require("genghis").renameFile() end,                    desc = " Rename file" },
  -- 	{"sfm", function() require("genghis").moveToFolderInCwd() end,             desc = " Move file" },
  -- 	{"sfM", function() require("genghis").moveAndRenameFile() end,             desc = " Move file and rename" },
  -- 	{"sfx", function() require("genghis").chmodx() end,                        desc = " chmod +x" },
  -- 	{"sfy", function() require("genghis").duplicateFile() end,                 desc = " Duplicate file" },
  --  {"sfd", function() require("genghis").trashFile({trashCmd = "trash"}) end, desc = " Move file to trash" },
  -- 	{"sfn", function() require("genghis").createNewFile() end,                 desc = " Create new file" },
  -- 	{"sfc", function() require("genghis").moveSelectionToNewFile() end,        desc = " Selection to new file", mode = "x" },
  --   -- stylua: ignore end
  -- },
}
