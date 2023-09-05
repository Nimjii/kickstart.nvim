-- deb.lua

local ls = require('luasnip')

return {
  ls.snippet('deb', {
    ls.text_node('<f:debug>{'),
    ls.insert_node(1, '_all'),
    ls.text_node('}</f:debug>'),
    ls.insert_node(0),
  })
}

