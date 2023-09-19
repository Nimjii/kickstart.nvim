-- oil.lua

return {
  'stevearc/oil.nvim',
  dependencies = {
    'folke/which-key.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = function (_, opts)
    require('which-key').register({
      o = { function () vim.cmd('Oil') end, 'Open oil in current directory'},
      O = {
        function ()
          require('utils.telescope').oil_picker(
            {
              show_preview = true,
              hidden = false,
              no_ignore = false,
            }
          )
        end,
        'Open oil in specific directory',
      },
    }, { prefix = '<leader>' })

    return opts
  end
}

