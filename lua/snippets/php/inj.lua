-- inj.lua

local ls = require('luasnip')
local utils = require('utils.snippets')

return {
  ls.snippet('inj', {
    ls.text_node({'/**', ' * @param '}),
    ls.function_node(utils.copy, 2),
    ls.text_node(' $'),
    ls.function_node(utils.copy, 1),
    ls.text_node({'', ' */', 'public function inject'}),
    ls.function_node(utils.copyUpper, 1),
    ls.text_node('('),
    ls.insert_node(2, 'Class'),
    ls.text_node(' $'),
    ls.insert_node(1, 'object'),
    ls.text_node({'): void', '{', '    $this->'}),
    ls.function_node(utils.copy, 1),
    ls.text_node(' = $'),
    ls.function_node(utils.copy, 1),
    ls.text_node(';'),
    ls.text_node({'', '}'}),
    ls.insert_node(0),
  })
}

