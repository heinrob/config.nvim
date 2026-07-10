require('luasnip').setup {}
require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
