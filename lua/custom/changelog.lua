local M = {}

local function write_and_open(filepath, fields)
  local fd = io.open(filepath, 'w')
  if fd == nil then
    vim.notify('changelog: could not create ' .. filepath, vim.log.levels.ERROR)
    return
  end
  fd:write(table.concat({
    '---',
    'text: "' .. fields.text:gsub('"', '\\"') .. '"',
    'audience: "' .. fields.audience .. '"',
    'type: "' .. fields.type .. '"',
    'urgency: "medium"',
    'closes:',
    '- ' .. fields.closes,
    'highlight: false',
  }, '\n') .. '\n')
  fd:close()
  vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
end

local function run_wizard(filepath, closes)
  vim.ui.input({ prompt = 'Changelog text: ' }, function(text)
    if text == nil or text == '' then return end

    vim.ui.select({ 'users', 'teachers', 'admin', 'technical' }, { prompt = 'Audience' }, function(audience)
      if audience == nil then return end

      vim.ui.select({ 'added', 'fixed', 'changed', 'deprecated', 'removed', 'other' }, { prompt = 'Type' }, function(change_type)
        if change_type == nil then return end
        write_and_open(filepath, {
          text = text,
          audience = audience,
          type = change_type,
          closes = closes,
        })
      end)
    end)
  end)
end

function M.create()
  local cwd = vim.fn.getcwd()

  local git_root = vim.trim(vim.fn.system { 'git', '-C', cwd, 'rev-parse', '--show-toplevel' })
  if vim.v.shell_error ~= 0 then
    vim.notify('changelog: not inside a git repository', vim.log.levels.ERROR)
    return
  end

  local branch = vim.trim(vim.fn.system { 'git', '-C', git_root, 'rev-parse', '--abbrev-ref', 'HEAD' })
  if vim.v.shell_error ~= 0 then
    vim.notify('changelog: could not determine branch name', vim.log.levels.ERROR)
    return
  end

  local filename = branch:gsub('/', '-') .. '.yml'
  local dir = git_root .. '/changelogs/unreleased'
  local filepath = dir .. '/' .. filename

  vim.fn.mkdir(dir, 'p')

  if vim.fn.filereadable(filepath) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
    return
  end

  local closes = branch:match '^(%d+)-' or '0'
  run_wizard(filepath, closes)
end

vim.api.nvim_create_user_command('Changelog', M.create, { desc = 'Create or open changelog entry for current branch' })

return M
