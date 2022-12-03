local M = {}
local tz = require('true-zen')

M.setup = function ()
  tz.setup {
     ui = {
        top = {
           showtabline = 0,
        },
        left = {
           number = true,
        },
     },
     modes = {
        ataraxis = {
           left_padding = 3,
           right_padding = 3,
           top_padding = 1,
           bottom_padding = 0,
           auto_padding = false,
        },
     },
  }
end

return M
