-- portal.lua

return {
  'cbochs/portal.nvim',
  dependencies = {
    'folke/which-key.nvim',
    'cbochs/grapple.nvim',
  },
  opts = function (_, opts)
    require('which-key').register({
      p = {
        name = ' Portal',
        c = {
          function ()
            require('portal.builtin').changelist.tunnel_backward()
          end,
          'Changelist backwards',
        },
        C = {
          function ()
            require('portal.builtin').changelist.tunnel_forward()
          end,
          'Changelist forwards',
        },
        j = {
          function ()
            require('portal.builtin').jumplist.tunnel_backward({
              filter = function (v)
                return v.buffer ~= vim.fn.bufnr() and string.find(vim.fn.bufname(v.buffer), 'neo-tree', nil, true) == nil
              end
            })
          end,
          'Jumplist backwards',
        },
        J = {
          function ()
            require('portal.builtin').jumplist.tunnel_forward({
              filter = function (v)
                return v.buffer ~= vim.fn.bufnr() and string.find(vim.fn.bufname(v.buffer), 'neo-tree', nil, true) == nil
              end
            })
          end,
          'Jumplist forwards',
        },
        g = {
          function ()
            require('portal.builtin').grapple.tunnel_backward()
          end,
          'Grapple backwards'
        },
        G = {
          function ()
            require('portal.builtin').grapple.tunnel_forward()
          end,
          'Grapple forwards',
        },
      },
    }, { prefix = '<leader>' })

    opts.labels = { 'j', 'k', 'h', 'l', 'a', 's', 'd', 'f' }

    return opts
  end,
}
