local Inspect = require 'libs.inspect'
local Binser = require 'libs.binser'

local path = 'puzzles.ser'

local function convert(filename)
  local file = assert(io.open(filename,'r'))
  local i,solution,box = 0,{},{}
  for line in file:lines() do
    if string.len(line) > 0 then
      if i == 2 then
        line = string.gsub(line,'   ','_ ')
        local row = {}
        for col in string.gmatch(line,'%S+') do
          table.insert(row,col)
        end
        table.insert(box,row)
      elseif i == 1 then
        local words = {}
        for word in string.gmatch(line,'(%d,%d)') do
          local t = {}
          for i in string.gmatch(word,'%d') do
            table.insert(t,tonumber(i))
          end
          table.insert(words,t)
        end
        table.insert(solution,words)
      end
    else
      i = i + 1
    end
  end
  return {
    box = box,
    solution = solution
  }
end

Binser.writeFile(path,convert('convert/puzzles/01.txt'))
Binser.appendFile(path,convert('convert/puzzles/02.txt'))
