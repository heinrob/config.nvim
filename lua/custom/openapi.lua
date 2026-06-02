-- regenerate OpenApi Spec with ReDoc
vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Generate OpenApi Spec in html from yaml using redoc',
  group = vim.api.nvim_create_augroup('my-openapi-spec', { clear = true }),
  pattern = { '*openapi-spec*.{yml,yaml}' },
  callback = function(f)
    vim.cmd(':silent !npx @redocly/cli build-docs --disableGoogleFont --output "$(git rev-parse --show-toplevel)/redoc-static.html" ' .. f.file)
    local fidget = require 'fidget'
    -- fidget.notify("")
    fidget.notify 'OpenApi Spec rebuilt.'
  end,
})
vim.keymap.set('n', 'gA', function() vim.cmd ':silent !open "$(git rev-parse --show-toplevel)/redoc-static.html"' end, { desc = '[G]oto Open[A]pi Spec' })
