-- snippets.lua

local M = {}

function M.copy(args)
  return args[1][1]
end

function M.copyUpper(args)
  return args[1][1]:gsub('^%l', string.upper)
end

return M

