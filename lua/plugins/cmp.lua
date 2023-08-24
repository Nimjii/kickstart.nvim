-- cmp.lua

local function copy(args)
  return args[1][1]
end

local function copyUpper(args)
  return args[1][1]:gsub('^%l', string.upper)
end

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
  },
  config = function ()
    local cmp = require('cmp')
    local ls = require('luasnip')

    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_snipmate').load({paths = '~/.config/nvim/snippets'})

    ls.config.setup {}

    ls.add_snippets('php', {
      ls.snippet('gs', {
        ls.text_node({'/**', ' * @return '}),
        ls.function_node(copy, 2),
        ls.text_node({'',' */', 'public function get'}),
        ls.function_node(copyUpper, 1),
        ls.text_node('(): '),
        ls.insert_node(2, 'string'),
        ls.text_node({'', '{', '    return $this->'}),
        ls.insert_node(1, 'foo'),
        ls.text_node({';', '}', '', '/**', ' * @param '}),
        ls.function_node(copy, 2),
        ls.text_node(' $'),
        ls.function_node(copy, 1),
        ls.text_node({'', ' * @return self', ' */', 'public function set'}),
        ls.function_node(copyUpper, 1),
        ls.text_node('('),
        ls.function_node(copy, 2),
        ls.text_node(' $'),
        ls.function_node(copy, 1),
        ls.text_node({'): self', '{', '    $this->'}),
        ls.function_node(copy, 1),
        ls.text_node(' = $'),
        ls.function_node(copy, 1),
        ls.text_node({';', '    return $this;', '}'}),
        ls.insert_node(0),
      })
    })

    cmp.setup({
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
      sources = cmp.config.sources(
        {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
        {
          { name = 'buffer'},
        }
      ),
    })
  end
}
