local gh = function(repo)
  return 'https://github.com/' .. repo
end

local function run_build(plugin, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    vim.notify(('Build failed for %s:\n%s'):format(plugin, output), vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('custom-pack-build-hooks', { clear = true }),
  callback = function(event)
    local data = event.data
    if not data or (data.kind ~= 'install' and data.kind ~= 'update') then return end

    local name = data.spec.name
    if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run_build(name, { 'make' }, data.path)
    elseif name == 'LuaSnip' and vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
      run_build(name, { 'make', 'install_jsregexp' }, data.path)
    elseif name == 'nvim-treesitter' then
      local ok, err = pcall(function()
        vim.cmd.packadd 'nvim-treesitter'
        vim.cmd.TSUpdate()
      end)
      if not ok then vim.notify(('Build failed for %s:\n%s'):format(name, err), vim.log.levels.WARN) end
    end
  end,
})

vim.pack.add({
  gh 'folke/tokyonight.nvim',
  gh 'NMAC427/guess-indent.nvim',
  gh 'folke/which-key.nvim',

  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-telescope/telescope.nvim',
  gh 'nvim-telescope/telescope-fzf-native.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',
  gh 'nvim-tree/nvim-web-devicons',

  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  gh 'nvim-mini/mini.nvim',
  gh 'stevearc/conform.nvim',
  gh 'lewis6991/gitsigns.nvim',

  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  gh 'rafamadriz/friendly-snippets',

  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'j-hui/fidget.nvim',
  gh 'neovim/nvim-lspconfig',

  gh 'folke/todo-comments.nvim',
  gh 'MeanderingProgrammer/render-markdown.nvim',
  gh 'nvim-mini/mini.icons',
  gh 'stevearc/oil.nvim',
}, { confirm = false })

require('custom.plugins.theme')
require('guess-indent').setup {}
require('custom.plugins.which-key')
require('custom.plugins.telescope')
require('custom.plugins.treesitter')
require('custom.plugins.mini')
require('custom.plugins.conform')
require('custom.plugins.gitsigns')
require('custom.plugins.lsp')
require('custom.plugins.blink')
require('custom.plugins.todo-comments')
require('custom.plugins.markdown')
require('custom.plugins.oil')
