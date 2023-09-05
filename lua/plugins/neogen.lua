-- neogen.lua

return {
  'danymat/neogen',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'folke/which-key.nvim',
  },
  opts = function (_, _)
    require('which-key').register({
      a = {
        name = ' Annotations',
        f = { function() require("neogen").generate({ type = "func" }) end, 'Function annotation' },
        c = { function() require("neogen").generate({ type = "class" }) end, 'Class annotation' },
        t = { function() require("neogen").generate({ type = "type" }) end, 'Type annotation' },
      },
    }, { prefix = '<leader>'})

    return {
      enabled = true,
      input_after_comment = true,
      snippet_engine = 'luasnip',
    }
  end,
}

