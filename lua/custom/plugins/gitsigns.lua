---@diagnostic disable-next-line: missing-fields
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end)
    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end)

    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[S]tage' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[R]eset' })
    map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[S]tage' })
    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[R]eset' })
    map('n', '<leader>hp', gitsigns.preview_hunk_inline, { desc = '[P]review' })
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Git [B]lame' })
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'inner [H]unk' })
  end,
}
