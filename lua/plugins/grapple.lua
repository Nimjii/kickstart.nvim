-- grapple.lua

return {
  'cbochs/grapple.nvim',
  dependencies = {
    'folke/which-key.nvim',
    'nvim-lua/plenary.nvim',
  },
  opts = function (_, opts)
    require('which-key').register({
      g = {
        name = '󰛢 Grapple',
        t = { function () require('grapple').toggle() end, 'Toggle tag' },
        p = { function () require('grapple').popup_tags() end, 'Tags popup' },
      },
    }, { prefix = '<leader>' })

    opts.scope = 'directory'

    return opts
  end,
}
