return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
      current_line_blame = true,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Navigation
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
        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[S]tage' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[R]eset' })
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[S]tage' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[R]eset' })
        map('n', '<leader>hp', gitsigns.preview_hunk_inline, { desc = '[P]review' })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Git [B]lame' })
        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'inner [H]unk' })
      end,
    },
  },
}
