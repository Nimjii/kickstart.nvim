-- lualine.lua

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  dependencies = {
    'f-person/git-blame.nvim',
  },
  opts = function (_, opts)
    local gitblame = require 'gitblame'

    opts.options = {
      icons_enabled = true,
      theme = 'catppuccin-macchiato',
      component_separators = { left = ' ', right = ' '},
      section_separators = { left = '', right = ''},
      always_divide_middle = true,
    }

    opts.sections = {
      lualine_a = {'mode'},
      lualine_b = {'diff', 'diagnostics'},
      lualine_c = {},
      lualine_x = {
        {
          gitblame.get_current_blame_text,
          cond = gitblame.is_blame_text_available,
        },
        'fileformat',
        'filetype',
      },
      lualine_y = {'progress'},
      lualine_z = {'location'},
    }

    opts.tabline = {
      lualine_a = {'branch'},
      lualine_b = {
        {
          'buffers',
          show_filename_only = true,
          hide_filename_extension = false,
          show_modified_status = true,
          mode = 0,
          use_mode_colors = true,
          symbols = {
            modified = ' 󰏪',
            alternate_file = '',
            directory = '',
          },
        },
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {
          'tabs',
          mode = 1,
          use_mode_colors = true,
          fmt = function (_, context)
            local buflist = vim.fn.tabpagebuflist(context.tabnr)
            local winnr = vim.fn.tabpagewinnr(context.tabnr)
            local bufnr = buflist[winnr]
            local mod = vim.fn.getbufvar(bufnr, '&mod')

            return context.tabnr .. (mod == 1 and ' 󰏪' or '')
          end
        },
      },
    }

    return opts
  end,
}

