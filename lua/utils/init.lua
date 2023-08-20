-- @module utils
require 'bootstrap'

local M = {}

function M.toggle_term_cmd(opts)
  local terms = mynvim.user_terminals
  -- if a command string is provided, create a basic table for Terminal:new() options
  if type(opts) == "string" then opts = { cmd = opts, hidden = true } end
  local num = vim.v.count > 0 and vim.v.count or 1
  -- if terminal doesn't exist yet, create it
  if not terms[opts.cmd] then terms[opts.cmd] = {} end
  if not terms[opts.cmd][num] then
    if not opts.count then opts.count = vim.tbl_count(terms) * 100 + num end
    if not opts.on_exit then opts.on_exit = function() terms[opts.cmd][num] = nil end end
    terms[opts.cmd][num] = require("toggleterm.terminal").Terminal:new(opts)
  end
  -- toggle the terminal
  terms[opts.cmd][num]:toggle()
end

function M.dir_picker(opts, fn)
  local action_set = require("telescope.actions.set")
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local conf = require("telescope.config").values
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")

  local find_command = (function ()
    if opts.find_command then
      if type(opts.find_command) == 'function' then
        return opts.find_command(opts)
      end
      return opts.find_command
    elseif 1 == vim.fn.executable('fd') then
      return { 'fd', '--type', 'd', '--color', 'never'}
    elseif 1 == vim.fn.executable('fdfind') then
      return { 'fdfind', '--type', 'd', '--color', 'never' }
    end
  end)()

  local command = find_command[1]
  local hidden = opts.hidden
  local no_ignore = opts.no_ignore

  if command == 'fd' or command == 'fdfind' or command == 'rg' then
    if hidden then
      find_command[#find_command + 1] = '--hidden'
    end

    if no_ignore then
      find_command[#find_command + 1] = '--no-ignore'
    end
  else
    vim.notify('telescope: You need to install either find, fd/fdfind or ripgrep', vim.log.levels.ERROR)
  end

  local getPreviewer = function ()
    if opts.show_preview then
      return conf.file_previewer(opts)
    else
      return nil
    end
  end

  vim.fn.jobstart(find_command, {
    stdout_buffered = true,
    on_stdout = function (_, data)
      if data then
        pickers.new(opts, {
          prompt_title = 'Select a Directory',
          finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
          previewer = getPreviewer(),
          sorter = conf.file_sorter(opts),
          attach_mappings = function (prompt_bufnr)
            action_set.select:replace(function ()
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local dirs = {}
              local selections = current_picker:get_multi_selection()

              if vim.tbl_isempty(selections) then
                table.insert(dirs, action_state.get_selected_entry().value)
              else
                for _, selection in ipairs(selections) do
                  table.insert(dirs, selection.value)
                end
              end

              actions.close(prompt_bufnr)
              fn({ search_dirs = dirs })
            end)
            return true
          end
        }):find()
      else
        vim.notify('No directories found', vim.log.levels.ERROR)
      end
    end
  })
end

return M
