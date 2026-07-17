-- Linting
local lint = require 'lint'

local function get_app_root(bufnr)
  local root = vim.fs.root(bufnr, { 'composer.json', '.git' })
  if root and vim.fs.basename(root) ~= 'app' then root = vim.fs.joinpath(root, 'app') end
  return root
end

lint.linters.phpstan.cmd = function()
  local root = get_app_root(0)
  return root and vim.fs.joinpath(root, 'tools/phpstan') or 'phpstan'
end

lint.linters_by_ft = {
  php = { 'phpstan' },
}

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = lint_augroup,
  pattern = '*.php',
  callback = function(event)
    local root = get_app_root(event.buf)
    if not root then return end

    local fixer = vim.fs.joinpath(root, 'tools/php-cs-fixer')
    if vim.fn.executable(fixer) ~= 1 then
      vim.notify('PHP CS Fixer is not executable: ' .. fixer, vim.log.levels.WARN)
      return
    end

    local filename = vim.api.nvim_buf_get_name(event.buf)
    local result = vim.system({ fixer, 'fix', filename }, {
      cwd = root,
      text = true,
    }):wait()

    if result.code ~= 0 then
      local message = vim.trim(result.stderr or '')
      vim.notify(message ~= '' and message or 'PHP CS Fixer failed', vim.log.levels.ERROR)
      return
    end

    -- Reload changes made to the file by the external fixer.
    vim.api.nvim_buf_call(event.buf, function() vim.cmd 'checktime' end)
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
