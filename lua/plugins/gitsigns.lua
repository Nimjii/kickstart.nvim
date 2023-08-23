-- gitsigns.lua

return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'folke/which-key.nvim'
  },
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      require('which-key').register({
        h = {
          name = ' Hunk Actions',
          v = { require('gitsigns').preview_hunk, 'Preview Hunk' },
          r = { require('gitsigns').reset_hunk, 'Reset Hunk' },
          s = { require('gitsigns').stage_hunk, 'Stage Hunk' },
          u = { require('gitsigns').undo_stage_hunk, 'Undo Stage' },
          d = { require('gitsigns').diffthis, 'Show Diff' },
        },
      }, { prefix = '<leader>'})

      vim.keymap.set('n', ']h', function ()
        if vim.wo.diff then return ']h' end
        vim.schedule(function ()
          require('gitsigns').next_hunk()

          vim.schedule(function ()
            vim.cmd.norm { args = { 'zz' }, bang = true }
          end)
        end)
        return '<Ignore>'
      end, { buffer = bufnr, desc = 'Go to next hunk' })

      vim.keymap.set('n', '[h', function ()
        if vim.wo.diff then return '[h' end
        vim.schedule(function ()
          require('gitsigns').prev_hunk()

          vim.schedule(function ()
            vim.cmd.norm { args = { 'zz' }, bang = true }
          end)
        end)
        return '<Ignore>'
      end, { buffer = bufnr, desc = 'Go to previous hunk' })

      vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'inner hunk'})
    end,
  },
}

