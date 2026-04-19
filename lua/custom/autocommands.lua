-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- restore last cursor position when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore last cursor position when opening a buffer',
  group = vim.api.nvim_create_augroup('my-editor-position', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  desc = 'Switch between relative and absolute line numbers between modes',
  group = vim.api.nvim_create_augroup('my-rel-nu', { clear = true }),
  callback = function(mode) vim.o.relativenumber = string.match(mode.match, '.*:i.*') == nil end,
})
