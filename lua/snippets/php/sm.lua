-- ms.lua

local ls = require('luasnip')
local utils = require('utils.snippets')

return {
  ls.snippet('sm', {
    ls.text_node({'/**', ' * @param '}),
    ls.function_node(utils.copy, 2),
    ls.text_node(' $'),
    ls.function_node(utils.copy, 1),
    ls.text_node({'', ' * @return self', ' */', 'public function set'}),
    ls.function_node(utils.copyUpper, 1),
    ls.text_node('('),
    ls.insert_node(2, 'string'),
    ls.text_node(' $'),
    ls.insert_node(1, 'foo'),
    ls.text_node({'): self', '{', '    $this->'}),
    ls.function_node(utils.copy, 1),
    ls.text_node(' = $'),
    ls.function_node(utils.copy, 1),
    ls.text_node({';', '    return $this;', '}'}),
    ls.insert_node(0),
  })
}

