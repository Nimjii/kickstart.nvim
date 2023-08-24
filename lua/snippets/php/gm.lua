-- mg.lua

local ls = require('luasnip')
local utils = require('utils.snippets')

return {
  ls.snippet('gm', {
    ls.text_node({'/**', ' * @return '}),
    ls.function_node(utils.copy, 2),
    ls.text_node({'',' */', 'public function get'}),
    ls.function_node(utils.copyUpper, 1),
    ls.text_node('(): '),
    ls.insert_node(2, 'string'),
    ls.text_node({'', '{', '    return $this->'}),
    ls.insert_node(1, 'foo'),
    ls.text_node({';', '}'}),
    ls.insert_node(0),
  })
}

