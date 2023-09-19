-- telescope.lua

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'folke/noice.nvim',
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
    require('telescope').load_extension('noice')

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
        d = { function () require('telescope.builtin').diagnostics() end, 'Find diagnostics' },
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
        n = { function () require('noice').cmd('telescope') end, 'Message history' },
        m = { function () require('telescope.builtin').man_pages() end, 'Find man pages' },
        s = { function () require('telescope.builtin').grep_string() end, 'Find word under cursor' },
        o = { function () require('telescope.builtin').oldfiles() end, 'Find recently opened files' },
        h = { function () require('telescope.builtin').marks() end, 'Find marks' },
        ['<CR>'] = { function () require('telescope.builtin').resume() end, 'Resume last search' },
      },
      ['<space>'] = { function () require('utils.telescope').buffers() end, 'Find existing buffers' },
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

    local handlers = {
      ['textDocument/declaration'] = require('utils.telescope').location_handler('LSP Declarations'),
      ['textDocument/definition'] = require('utils.telescope').location_handler('LSP Definitions'),
      ['textDocument/implementation'] = require('utils.telescope').location_handler('LSP Implementations'),
      ['textDocument/typeDefinition'] = require('utils.telescope').location_handler('LSP Type Definitions'),
      ['textDocument/references'] = require('utils.telescope').location_handler('LSP References'),
    }

    for req, handler in pairs(handlers) do
      vim.lsp.handlers[req] = handler
    end

    opts.defaults = {
      buffer_previewer_maker = require('utils.telescope').previewer_maker,
      path_display = { 'truncate' },
      preview = {
        mime_hook = function (filepath, bufnr, opts)
          local is_image = function (path)
            local image_extensions = {'gif', 'png', 'jpg', 'jpeg'}
            local split_path = vim.split(path:lower(), '.', { plain = true })
            local extension = split_path[#split_path]

            return vim.tbl_contains(image_extensions, extension)
          end

          if is_image(filepath) then
            local term = vim.api.nvim_open_term(bufnr, {})
            local function send_output(_, data, _)
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d .. '\r\n')
              end
            end

            vim.fn.jobstart(
              { 'catimg', filepath },
              { on_stdout = send_output, stdout_buffered = true, pty = true }
            )
          else
            require('telescope.previewers.utils').set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
          end
        end
      },
      prompt_prefix = string.format('%s ', ' '),
      selection_caret = string.format('%s ', '❯'),
      file_ignore_patterns = {
        "node_modules/",
        ".git/",
      },
    }

    return opts
  end,
}

