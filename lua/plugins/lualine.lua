-- lualine.lua

local function get_lsps()
  local output = ''
  local clients = vim.lsp.get_active_clients({
    bufnr = vim.api.nvim_get_current_buf(),
  })

  for i, client in pairs(clients) do
    if i == 1 then
      output = output .. client.name
    else
      output = output .. ', ' .. client.name
    end
  end

  return output
end

local function get_grapple()
  local key = require("grapple").key()
  return "󰛢 [" .. key .. "]"
end

local function maximize_status()
  return vim.t.maximized and '󰁌' or ''
end

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  dependencies = {
    'declancm/maximize.nvim',
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
      disabled_filetypes = {
        statusline = { 'neo-tree' },
      }
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
      lualine_b = { get_lsps },
      lualine_c = {},
      lualine_x = { maximize_status },
      lualine_y = {
        { get_grapple, cond = require('grapple').exists },
      },
      lualine_z = {
        {
          'filename',
          newfile_status = true,
          symbols = {
            modified = '󰏪',
            readonly = '',
          },
        },
      },
    }

    return opts
  end,
}

