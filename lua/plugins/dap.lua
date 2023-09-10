-- dap.lua

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      opts = {
        floating = {
          border = 'rounded',
        },
      },
    },

    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'folke/which-key.nvim',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    local defaults = {
      type = "php",
      request = "launch",
      port = 9003,
    }

    require('mason-nvim-dap').setup {
      automatic_setup = true,
      automatic_installation = true,
      handlers = {
        function (config)
          require('mason-nvim-dap').default_setup(config)
        end,
        php = function (config)
          config.adapters = {
            type = "executable",
            command = "node",
            args = { "/Users/l.spreitzer/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
          }

          config.configurations = {
            vim.tbl_deep_extend('force', defaults, {
              name = "NXT",
              hostname = "www-nxtcontrol-com.ddev.site",
              pathMappings = {
                ["/var/www/html"] = "/Users/l.spreitzer/PhpstormProjects/www-nxtcontrol-com",
              },
            }),
            vim.tbl_deep_extend('force', defaults, {
              name = "OeSV",
              hostname = "www-segelverband-at.ddev.site",
              pathMappings = {
                ["/var/www/html"] = "/Users/l.spreitzer/PhpstormProjects/segelverband-at",
              },
            }),
            vim.tbl_deep_extend('force', defaults, {
              name = "PVÖ",
              hostname = "www-pvoe-at.ddev.site",
              pathMappings = {
                ["/var/www/html"] = "/Users/l.spreitzer/PhpstormProjects/www-pvoe-at/src",
              },
            }),
            vim.tbl_deep_extend('force', defaults, {
              name = "VPG",
              hostname = "www-viennapass-de.ddev.site",
              pathMappings = {
                ["/var/www/html"] = "/Users/l.spreitzer/PhpstormProjects/www-viennapass-de/src",
              },
            }),
          }

          require('mason-nvim-dap').default_setup(config)
        end,
      },
      ensure_installed = {
        'php',
      },
    }

    require('which-key').register({
      d = {
        name = ' Debugger',
        b = { dap.toggle_breakpoint, 'Toggle breakpoint' },
        B = {
          function ()
            dap.set_breakpoint(vim.fn.input 'Condition: ')
          end,
          'Set conditional breakpoint',
        },
        c = { dap.continue, 'Start/Continue' },
        C = { dap.clear_breakpoints, 'Clear all breakpoints' },
        e = {
          function()
            vim.ui.input({ prompt = "Expression: " }, function(expr)
              if expr then require("dapui").eval(expr, { enter = true }) end
            end)
          end,
          'Evaluate expression',
        },
        i = { dap.step_into, 'Step into' },
        s = { dap.run_to_cursor, 'Run to cursor' },
        o = { dap.step_over, 'Step over' },
        u = { dapui.toggle, 'Toggle debugger' },
      },
    }, { prefix = '<leader>' })

    require('which-key').register({
      d = {
        name = ' Debugger',
        e = { dapui.eval, 'Evaluate expression' },
      },
    }, { prefix = '<leader>', mode = 'v' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}

