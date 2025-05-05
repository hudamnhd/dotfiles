local config_files = {
  "options",
  "commands",
  "keymaps",
  "lazyplug",
}

for _, file in pairs(config_files) do

  local success = pcall(require, file)
  if not success then
    vim.notify("Failed to load a config file " .. file)
    break
  end

end
