vim.keymap.set('', '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })

local javascript_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local prettier_config_root = assert(require('conform.formatters.prettierd').cwd)

local function has_prettier_config(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == '' then return false end

  return prettier_config_root({ command = 'prettierd' }, {
    buf = bufnr,
    filename = filename,
    dirname = vim.fs.dirname(filename),
    shiftwidth = vim.bo[bufnr].shiftwidth,
  }) ~= nil
end

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    local filetype = vim.bo[bufnr].filetype

    if disable_filetypes[filetype] then
      return nil
    end

    -- Without a project config, Prettier's defaults or the LSP can replace the
    -- indentation already detected by guess-indent across the whole file.
    if javascript_filetypes[filetype] and not has_prettier_config(bufnr) then return nil end

    return {
      timeout_ms = 500,
      lsp_format = javascript_filetypes[filetype] and 'never' or 'fallback',
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
  },
}
