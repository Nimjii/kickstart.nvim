-- marks.lua

return {
  'chentoast/marks.nvim',
  opts = {
    default_mappings = true,
    cyclic = true,
    force_write_shada = false,
    refresh_interval = 150,
    sign_priority = 10,
    mappings = {
      next = ']m',
      prev = '[m',
      next_bookmark = '}m',
      prev_bookmark = '{m'
    },
  },
}
