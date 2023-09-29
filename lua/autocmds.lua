-- @module utils.autocmds

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    require('illuminate').pause_buf()
    vim.wait(25)
    vim.highlight.on_yank()
    vim.wait(25)
    require('illuminate').resume_buf()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Delete trailing whitespaces ]]
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  command = [[%s/\s\+$//e]],
})
