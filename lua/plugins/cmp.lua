-- cmp.lua

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',

    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'ray-x/cmp-treesitter',
    {
      'js-everts/cmp-tailwind-colors',
      opts = {
        enable_alpha = true,
        format = function(itemColor)
          return {
            fg = itemColor,
            bg = nil,
            text = '󰌁',
          }
        end,
      },
    },
  },
  config = function ()
    local cmp = require('cmp')
    local ls = require('luasnip')
    local icons = {
      Text = "",
      Method = "",
      Function = "󰊕",
      Constructor = "",
      Field = "󰷳",
      Variable = "󰫧",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "󰈙",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "",
    }

    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').lazy_load({paths = '~/.config/nvim/lua/snippets'})
    require('luasnip.loaders.from_snipmate').load({paths = '~/.config/nvim/snippets'})

    ls.config.setup {}

    cmp.setup({
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, item)
          if item.kind == 'Color' then
            item = require('cmp-tailwind-colors').format(entry, item)

            if item.kind ~= 'Color' then
              item.menu = 'Color'
              return item
            end
          end

          item.menu = item.kind

          if icons[item.kind] then
            item.kind = icons[item.kind] .. ' '
          else
            item.kind = ''
          end

          return item
        end,
      },
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'buffer'},
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'treesitter'},
        {
          name = 'path',
          option = {
            trailing_slash = true,
          },
        },
      },
    })

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer'},
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        {
          { name = 'path' },
        },
        {
          { name = 'cmdline' },
        }
      )
    })
  end
}
