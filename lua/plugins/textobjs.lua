-- textobjs.lua

return {
  "chrisgrieser/nvim-various-textobjs",
  event = "VeryLazy",
  opts = {
    useDefaultKeymaps = false,
  },
  keys = {
    { 'ii', mode = { 'o', 'x' }, function () require('various-textobjs').indentation('inner', 'inner') end, desc = 'inner-inner indentation' },
    { 'ai', mode = { 'o', 'x' }, function () require('various-textobjs').indentation('outer', 'inner') end, desc = 'outer-inner indentation' },
    { 'aI', mode = { 'o', 'x' }, function () require('various-textobjs').indentation('outer', 'outer') end, desc = 'outer-outer indentation' },
    { 'R', mode = { 'o', 'x' }, function () require('various-textobjs').restOfIndentation() end, desc = 'rest of indentation' },
    { 'ig', mode = { 'o', 'x' }, function () require('various-textobjs').greedyOuterIndentation('inner') end, desc = 'inner greedy outer indentation' },
    { 'ag', mode = { 'o', 'x' }, function () require('various-textobjs').greedyOuterIndentation('outer') end, desc = 'outer greedy outer indentation' },
    { 'iS', mode = { 'o', 'x' }, function () require('various-textobjs').subword('inner') end, desc = 'inner subword' },
    { 'aS', mode = { 'o', 'x' }, function () require('various-textobjs').subword('outer') end, desc = 'outer subword' },
    { 'C', mode = { 'o', 'x' }, function () require('various-textobjs').toNextClosingBracket() end, desc = 'to next closing bracket' },
    { 'gG', mode = { 'o', 'x' }, function () require('various-textobjs').entireBuffer() end, desc = 'entire buffer' },
    { 'n', mode = { 'o', 'x' }, function () require('various-textobjs').nearEoL() end, desc = 'to near EoL' },
    { 'i_', mode = { 'o', 'x' }, function () require('various-textobjs').lineCharacterwise('inner') end, desc = 'inner current line character wise' },
    { 'a_', mode = { 'o', 'x' }, function () require('various-textobjs').lineCharacterwise('outer') end, desc = 'outer current line character wise' },
    { '|', mode = { 'o', 'x' }, function () require('various-textobjs').column() end, desc = 'column' },
    { 'iv', mode = { 'o', 'x' }, function () require('various-textobjs').value('inner') end, desc = 'inner value of key-value pair' },
    { 'av', mode = { 'o', 'x' }, function () require('various-textobjs').value('outer') end, desc = 'outer value of key-value pair' },
    { 'ik', mode = { 'o', 'x' }, function () require('various-textobjs').key('inner') end, desc = 'inner key of key-value pair' },
    { 'ak', mode = { 'o', 'x' }, function () require('various-textobjs').key('outer') end, desc = 'outer key of key-value pair' },
    { 'im', mode = { 'o', 'x' }, function () require('various-textobjs').chainMember('inner') end, desc = 'inner chain member' },
    { 'am', mode = { 'o', 'x' }, function () require('various-textobjs').chainMember('outer') end, desc = 'outer chain member' },
    { 'ix', mode = { 'o', 'x' }, function () require('various-textobjs').htmlAttribute('inner') end, desc = 'inner html attribute' },
    { 'ax', mode = { 'o', 'x' }, function () require('various-textobjs').htmlAttribute('outer') end, desc = 'outer html attribute' },
    { 'iD', mode = { 'o', 'x' }, function () require('various-textobjs').doubleSquareBrackets('inner') end, desc = 'inner double square brackets' },
    { 'aD', mode = { 'o', 'x' }, function () require('various-textobjs').doubleSquareBrackets('outer') end, desc = 'outer double square brackets' },
  },
}

