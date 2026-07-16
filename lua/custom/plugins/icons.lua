local icons = require 'mini.icons'

icons.setup {}

-- Telescope still expects nvim-web-devicons. Expose mini.icons through the
-- compatible API so it uses the same glyphs as every other plugin.
icons.mock_nvim_web_devicons()
