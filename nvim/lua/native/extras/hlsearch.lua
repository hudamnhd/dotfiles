-------------------------------------------------------------------------------
-- Auto HLSearch ==============================================================
-------------------------------------------------------------------------------
vim.on_key(function(char)
  if vim.fn.mode(1) == 'n' then
    local new_hlsearch = vim.iter({ '<CR>', 'n', 'N', '*', '#', '?', '/' }):find(vim.fn.keytrans(char)) ~= nil
    if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
  end
end, vim.api.nvim_create_namespace('hlsearch'))
