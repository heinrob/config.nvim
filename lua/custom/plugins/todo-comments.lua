-- Highlight todo, notes, etc in comments
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ---@module 'todo-comments'
  ---@type function|TodoOptions
  ---@diagnostic disable-next-line: missing-fields
  config = function()
    require('todo-comments').setup { signs = true }
    vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next [T]odo comment' })
    vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Prev [T]odo comment' })
  end,
}
