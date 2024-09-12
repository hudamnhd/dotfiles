local winopts = {
  sm = {
    no_preview = {
      -- row = 0.85,
      -- col = 0.5,
      height = 0.45,
      width = 0.75,
      preview = { hidden = "hidden" },
    },
    relative_cursor = {
      relative = "cursor",
      row = 1.01,
      col = 0,
      height = 0.30,
      width = 0.30,
    },
  },
  md = {
    flex = {
      height = 0.65,
      width = 0.65,
      preview = {
        layout = "flex",
        vertical = "up:50%",
      },
    },
  },
  lg = {
    flex = {
      height = 0.9,
      width = 0.9,
      preview = {
        layout = "flex",
        vertical = "up:65%", -- up|down:size
        horizontal = "left:50%", -- right|left:size
      },
    },
    vertical_corner = {
      row = 0.85,
      col = 1,
      height = 0.9,
      width = 85,
      preview = {
        layout = "vertical",
        vertical = "up:65%", -- up|down:size
      },
    },
    vertical = {
      height = 0.95,
      width = 0.95,
      preview = {
        layout = "vertical",
        vertical = "up:65%", -- up|down:size
      },
    },
  },
  fullscreen = {
    flex = {
      fullscreen = true,
      preview = {
        layout = "flex",
        vertical = "up:65%", -- up|down:size
        horizontal = "left:50%", -- right|left:size
      },
    },
    vertical = {
      fullscreen = true,
      preview = {
        layout = "vertical",
        vertical = "up:65%",
      },
    },
  },
}

return winopts
