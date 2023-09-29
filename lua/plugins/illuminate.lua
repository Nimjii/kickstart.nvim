-- illuminate.lua

return {
  'RRethy/vim-illuminate',
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function ()
    require('illuminate').configure({
      filetypes_denylist = {
          'dirbuf',
          'dirvish',
          'fugitive',
          'neo-tree filesystem',
      },
    })

    vim.keymap.del('n', '<a-p>')
    vim.keymap.del('n', '<a-n>')
    vim.keymap.del({ 'o', 'x' }, '<a-i>')

    vim.keymap.set('n', '[i', function () require('illuminate').goto_prev_reference() end, { desc = 'Move to previous reference' })
    vim.keymap.set('n', ']i', function () require('illuminate').goto_next_reference() end, { desc = 'Move to next reference' })
    vim.keymap.set({ 'o', 'x' }, 'ao', function () require('illuminate').textobj_select() end, { desc = 'illuminated text' })
  end,
}
