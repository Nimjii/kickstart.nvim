-- aerial.lua

return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    show_trailing_blankline_indent = false,
    use_treesitter = true,
    char = "▏",
    context_char = "▏",
    show_current_context = true,
  },
}
