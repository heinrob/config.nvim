require('todo-comments').setup { signs = true }
vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next [T]odo comment' })
vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Prev [T]odo comment' })
