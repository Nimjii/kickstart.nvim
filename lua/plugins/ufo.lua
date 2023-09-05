-- ufo.lua

local function handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
      else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, {chunkText, hlGroup})
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
      end
      curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, {suffix, 'MoreMsg'})
  return newVirtText
end

return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'folke/which-key.nvim',
    'kevinhwang91/promise-async',
  },
  opts = function (_, opts)
    require('which-key').register({
      z = {
        R = { function () require('ufo').openAllFolds() end, 'Open all folds' },
        M = { function () require('ufo').closeAllFolds() end, 'Close all folds' },
        p = { function () require('ufo').peekFoldedLinesUnderCursor() end, 'Close all folds' },
      },
    })

    opts.fold_virt_text_handler = handler
    opts.provider_selector = function (_, filetype, buftype)
      return (filetype == '' or buftype == 'nofile') and 'indent' or {'treesitter', 'indent'}
    end
  end,
}
