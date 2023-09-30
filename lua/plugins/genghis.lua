-- ghengis.lua

return {
  'chrisgrieser/nvim-genghis',
  dependencies = {
    'folke/which-key.nvim',
    'stevearc/dressing.nvim',
  },
  config = function ()
    local genghis = require('genghis')

    require('which-key').register({
      F = {
        name = ' Files',
        d = { genghis.duplicateFile, 'Duplicate file' },
        m = { genghis.moveAndRenameFile, 'Move and rename file' },
        n = { genghis.createNewFile, 'Create a new file' },
        r = { genghis.renameFile, 'Rename file' },
        t = { function () genghis.trashFile() end, 'Trash file' },
        x = { genghis.chmodx, 'Make file executable' },
        y = { genghis.copyFilename, 'Copy filename' },
        Y = { genghis.copyFilepath, 'Copy filepath' },
      },
    }, { prefix = '<leader>' })

    require('which-key').register({
      F = {
        name = ' Files',
        x = { genghis.moveSelectionToNewFile, 'Move selection to new file' },
      },
    }, { mode = 'x', prefix = '<leader>' })
  end
}
