return {
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup({
        colors = {
          palette = {
            -- change all usages of these colors
            sumiInk0 = '#2A2A37',
          },
        },
        overrides = function(colors)
          return {
            -- Assign a static color to strings
            -- LineNr = { fg = colors.palette.boatYellow1 },
            Visual = { bg = colors.palette.waveBlue2 },
          }
        end,
      })
    end,
  },
}
