-- Dependencies
require 'autocmds'

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    'windwp/nvim-autopairs',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  {
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
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {
      icons = {
        group = '',
      }
    }
  },

  {
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
            v = { require('gitsigns').preview_hunk, 'Pre[v]iew Hunk' },
            r = { require('gitsigns').reset_hunk, '[R]eset Hunk' },
            s = { require('gitsigns').stage_hunk, '[S]tage Hunk' },
            u = { require('gitsigns').undo_stage_hunk, '[U]ndo Stage' },
            d = { require('gitsigns').diffthis, 'Show [D]iff' },
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
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },

  {
    'f-person/git-blame.nvim',
    dependencies = {
      'folke/which-key.nvim',
    },
    opts = function (_, opts)
      require('which-key').register({
        G = {
          name = ' Git blame',
          o = { '<cmd>GitBlameOpenCommitURL<cr>', 'Open commit url' },
          h = { '<cmd>GitBlameCopySHA<cr>', 'Copy commit SHA' },
          u = { '<cmd>GitBlameCopyCommitURL<cr>', 'Copy commit url' },
          f = { '<cmd>GitBlameOpenFileURL<cr>', 'Open file url' },
        },
      }, { prefix = '<leader>'})

      return opts
    end,
    event = 'VeryLazy',
  },

  {
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
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'akinsho/toggleterm.nvim',
    dependencies = {
      'folke/which-key.nvim',
    },
    cmd = { "ToggleTerm", "TermExec" },
    event = 'VimEnter',
    opts = function (_, opts)
      require('which-key').register({
        t = {
          name = ' ToggleTerm',
          f = { '<cmd>ToggleTerm direction=float<cr>', 'ToggleTerm float' },
          h = { '<cmd>ToggleTerm size=10 direction=horizontal<cr>', 'ToggleTerm horizontal split' },
          v = { '<cmd>ToggleTerm size=80 direction=vertical<cr>', 'ToggleTerm vertical split' },
          l = { function () require('utils').toggle_term_cmd 'lazygit' end, 'ToggleTerm LazyGit' },
          d = { function () require('utils').toggle_term_cmd 'lazydocker' end, 'ToggleTerm LazyDocker' },
          r = { function () require('utils').toggle_term_cmd 'ranger' end, 'ToggleTerm Ranger' },
          s = { function () require('utils').toggle_term_cmd 'lftp' end, 'ToggleTerm LFTP' },
        },
      }, { prefix = '<leader>'})

      opts.size = 10
      opts.on_create = function()
        vim.opt.foldcolumn = "0"
        vim.opt.signcolumn = "no"
      end
      opts.open_mapping = [[<F7>]]
      opts.shading_factor = 2
      opts.direction = "float"
      opts.float_opts = { border = "rounded" }

      return opts
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'folke/which-key.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    opts = function (_, opts)
      require('which-key').register({
        f = {
          name = '󰍉 Find',
          f = {
            function ()
              require('utils.telescope').dir_picker(
                {
                  show_preview = true,
                  hidden = false,
                  no_ignore = false,
                },
                require('telescope.builtin').find_files,
                false
              )
            end,
            'Find files',
          },
          F = {
            function ()
              require('utils.telescope').dir_picker(
                {
                  show_preview = true,
                  hidden = true,
                  no_ignore = true,
                  no_ignore_parent = true,
                },
                require('telescope.builtin').find_files,
                false
              )
            end,
            'Find all files',
          },
          c = { function () require('telescope.builtin').git_commits() end, 'Find commits' },
          b = { function () require('telescope.builtin').git_branches() end, 'Find branches' },
          g = { function () require('telescope.builtin').git_files() end, 'Find git files' },
          w = {
            function ()
              require('utils.telescope').dir_picker(
                {
                  show_preview = true,
                  hidden = false,
                  no_ignore = false,
                },
                require('telescope.builtin').live_grep,
                true
              )
            end,
            'Find words'
          },
          W = {
            function ()
              require('utils.telescope').dir_picker(
                {
                  show_preview = true,
                  hidden = true,
                  no_ignore = true,
                  no_ignore_parent = true,
                  additional_args = function (args)
                    return vim.list_extend(args, { "--hidden", "--no-ignore" })
                  end
                },
                require('telescope.builtin').live_grep,
                true
              )
            end,
            'Find words in all files',
          },
          j = { function () require('telescope.builtin').jumplist() end, 'Jumplist' },
          m = { function () require('telescope.builtin').man_pages() end, 'Find man pages' },
          s = { function () require('telescope.builtin').grep_string() end, 'Find word under cursor' },
          o = { function () require('telescope.builtin').oldfiles() end, 'Find recently opened files' },
          h = { function () require('telescope.builtin').marks() end, 'Find marks' },
          ['<CR>'] = { function () require('telescope.builtin').resume() end, 'Resume last search' },
        },
        ['<space>'] = { function () require('telescope.builtin').buffers() end, 'Find existing buffers' },
        ['/'] = {
          function ()
            require('telescope.builtin').current_buffer_fuzzy_find(
              require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
              }
            )
          end,
          'Fuzzily search in current buffer',
        },
      }, { prefix = '<leader>'})

      opts.defaults = {
        file_ignore_patterns = {
          "node_modules/*",
          ".git/*",
        },
      }

      return opts
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
}, {})

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

--[[ Setting options ]]

--See `:help vim.o`
vim.o.breakindent= true
vim.o.clipboard= 'unnamedplus'
vim.o.completeopt= 'menuone,noselect'
vim.o.copyindent= true
vim.o.cursorline= true
vim.o.hlsearch= false
vim.o.ignorecase= true
vim.o.mouse= 'a'
vim.o.scrolloff= 8
vim.o.smartcase= true
vim.o.termguicolors= true
vim.o.timeoutlen= 300
vim.o.undofile= true
vim.o.updatetime= 250
vim.o.wrap= false

vim.wo.relativenumber= true
vim.wo.signcolumn= 'yes'

vim.g.gitblame_ignored_filetypes = { "lock" }
vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_template = "<summary> • <date> • <author>"

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set({ 'n' }, 'n', 'nzzzv', { silent = true })
vim.keymap.set({ 'n' }, 'N', 'Nzzzv', { silent = true })
vim.keymap.set({ 'n' }, 'd', 'd', { desc = 'Cut', silent = true })
vim.keymap.set({ 'n' }, 'D', '"_d', { desc = 'Delete', silent = true })
vim.keymap.set({ 'n' }, 'c', '"_c', { desc = 'Change', silent = true })
vim.keymap.set({ 'n' }, 'x', '"_x', { desc = 'Delete character', silent = true })
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set({ 'n' }, '<C-j>', '<C-w>j', { desc = 'Move to below split' })
vim.keymap.set({ 'n' }, '<C-k>', '<C-w>k', { desc = 'Move to above split' })
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l', { desc = 'Move to right split' })
vim.keymap.set({ 'n' }, '<C-Up>', '<cmd>resize -2<CR>', { desc = 'Resize split up' })
vim.keymap.set({ 'n' }, '<C-Down>', '<cmd>resize +2<CR>', { desc = 'Resize split down' })
vim.keymap.set({ 'n' }, '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Resize split left' })
vim.keymap.set({ 'n' }, '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Resize split right' })
vim.keymap.set({ 'n' }, '<C-s>', '<C-w>s', { desc = 'Create horizontal split' })
vim.keymap.set({ 'n' }, '<C-v>', '<C-w>v', { desc = 'Create vertical split' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Navigation mappings
vim.keymap.set('n', ']t', function () vim.cmd.tabnext() end, { desc = 'Next tab' })
vim.keymap.set('n', '[t', function () vim.cmd.tabprevious() end, { desc = 'Previous tab' })
vim.keymap.set('n', ']b', function () require('utils.buffer').nav(vim.v.count > 0 and vim.v.count or 1) end, { desc = 'Previous buffer' })
vim.keymap.set('n', '[b', function () require('utils.buffer').nav(-(vim.v.count > 0 and vim.v.count or 1)) end, { desc = 'Previous buffer' })
vim.keymap.set('n', ']t', function() vim.cmd.tabnext() end, { desc = "Next tab" })
vim.keymap.set('n', '[t', function() vim.cmd.tabprevious() end, { desc = "Previous tab" })

-- Buffer mappings
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', '<cmd>confirm q<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>n', '<cmd>enew<cr>', { desc = 'New File' })
vim.keymap.set('n', '<leader>c', '<cmd>bd<cr>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>C', '<cmd>bd!<cr>', { desc = 'Force close buffer' })

vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
