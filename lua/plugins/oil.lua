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

    opts.view_options = {
      show_hidden = true,
      is_always_hidden = function (name)
        return name == '.DS_Store'
      end
    }

    opts.keymaps = {
      ['<C-b>'] = 'actions.preview_scroll_up',
      ['<C-f>'] = 'actions.preview_scroll_down',
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-s>'] = 'actions.select_split',
      ['<C-v>'] = 'actions.select_vsplit',
      ['<C-o>'] = {
        callback = function ()
          local oil = require('oil')
          local name = oil.get_cursor_entry()['parsed_name']
          local path = oil.get_current_dir() .. name

          require('utils').system_open(path)
        end,
        desc = 'Open in finder',
        nowait = true,
      },
    }

    return opts
  end
}

