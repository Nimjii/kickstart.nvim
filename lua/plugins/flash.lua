-- flash.lua

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    jump = {
      autojump = true,
    },
    modes = {
      char = {
        autohide = true,
        multi_line = false,
      },
    },
    search = {
      multi_window = false,
    },
  },
  keys = {
    { 's', mode = { 'n', 'o', 'x' }, function () require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = { 'n', 'o', 'x' }, function () require('flash').treesitter() end, desc = 'Flash Treesitter' },
    { 'r', mode = { 'o', 'x' }, function () require('flash').treesitter_search() end, desc = 'Treesitter search' },
  },
}
