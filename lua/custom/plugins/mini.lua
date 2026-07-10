require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function(args)
  if statusline.is_truncated(args.trunc_width) then return '%2l:%-2v' end
  return '%2l|%L:%-2v'
end
