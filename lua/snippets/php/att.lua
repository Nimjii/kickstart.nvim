-- att.lua

local ls = require('luasnip')
local utils = require('utils.snippets')

return {
  ls.snippet('att', {
    ls.text_node({'/**', ' * @var '}),
    ls.function_node(utils.copy, 2),
    ls.text_node({'',' */', 'protected '}),
    ls.insert_node(2, 'string'),
    ls.text_node(' $'),
    ls.insert_node(1, 'foo'),
    ls.text_node({';', ''}),
    ls.insert_node(0),
  })
}
