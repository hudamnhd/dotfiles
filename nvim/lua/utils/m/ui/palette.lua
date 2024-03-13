local blue   = 0x65D1FF
local green  = 0x3EFFDC
local purple = 0xFF61EF
local red    = 0xFF4A4A
local yellow = 0xE5C07B
local fg     = 0xc3ccdc
local lgray  = 0x848B98
local gray1  = 0x5C6370
local gray2  = 0x4B5263
local gray3  = 0x2c3043
local gray4  = 0x112638
local bg     = 0x112638
local dark   = 0x21252C

-- local blue   = 0x61AFEF
-- local green  = 0x98C379
-- local purple = 0xC678DD
-- local red    = 0xE06C75
-- local yellow = 0xE5C07B
-- local fg     = 0xABB2BF
-- local lgray  = 0x848B98
-- local gray1  = 0x5C6370
-- local gray2  = 0x4B5263
-- local gray3  = 0x3E4452
-- local gray4  = 0x2C323D
-- local bg     = 0x011627
-- local dark   = 0x21252C

-- local blue   = #65D1FF
-- local green  = #3EFFDC
-- local purple = #FF61EF
-- local red    = #FF4A4A
-- local yellow = #E5C07B
-- local fg     = #c3ccdc
-- local lgray  = #848B98
-- local gray1  = #5C6370
-- local gray2  = #4B5263
-- local gray3  = #3E4452
-- local gray4  = #313244
-- local bg     = #112638
-- local dark   = #21252C


local set_hl = vim.api.nvim_set_hl

for k, v in pairs({
  N  = { bg = green,  fg = bg     },
  I  = { bg = blue,   fg = bg     },
  V  = { bg = purple, fg = bg     },
  R  = { bg = red,    fg = bg     },
  E  = { bg = yellow, fg = bg     },

  FN = { bg = gray4,  fg = green  },
  FI = { bg = gray4,  fg = blue   },
  FV = { bg = gray4,  fg = purple },
  FR = { bg = gray4,  fg = red    },
  FE = { bg = gray4,  fg = yellow },

  A  = { bg = fg,     fg = bg     },
  B  = { bg = gray3,  fg = fg     },
  C  = { bg = gray4,  fg = fg     },
  L  = { bg = gray3,  fg = green  }, -- alternate buffer

  AS = { bg = fg,     fg = bg     }, -- A separator
  BS = { bg = gray3,  fg = bg     }, -- B separator
  CS = { bg = gray4,  fg = gray1  }, -- C separator
  LS = { bg = gray2,  fg = bg     }, -- L separator
  DS = { bg = gray4,  fg = gray3  },
  BG = { bg = bg,     fg = gray3  }, -- background
  EL = { bg = bg,     fg = gray1  }, -- ellipsis
  NB = { bg = gray3,  fg = bg     }, -- no buffers
}) do
  set_hl(0, 'Statusline'..k, v)
end

local cache = {}

return {
  hl = function(name)
    if not cache[name] then
      cache[name] = '%#Statusline'..name..'#'
    end
    return cache[name]
  end,
}
