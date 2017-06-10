-- box.lua

local Entity = require 'entities.entity'
local Square = require 'entities.square'

local Box = Class('Box',Entity)

-- local box = {
--   { 'I4', 'I4', 'I4', 'I4', 'T4', },
--   { 'T4', 'Z4', 'Z4', 'T4', 'T4', },
--   { 'Z4', 'Z4', 'L4', 'O4', 'O4', },
--   { 'L4', 'L4', 'L4', 'O4', 'O4', },
-- }

local box = {
  { 'I4','I4','I4','I4','T4',nil },
  {  nil,'L4','Z4','T4','T4','T4' },
  {  nil,'L4','Z4','Z4','O4','O4' },
  {  nil,'L4','L4','Z4','O4','O4' },
}

function Box:checkSolution()
  -- local items,len = self.world:queryRect(self.x,self.y,self.w,self.h)
end

function Box:initialize(world,x,y)
  Entity.initialize(self,world,x,y,#box[1]*conf.squareSize,#box*conf.squareSize)

  self.squares,self.count = {},0
  for i=1,#box do
    for j=1,#box[i] do
      if box[i][j] then
        local square = Square:new(world,x+(j-1)*conf.squareSize,y+(i-1)*conf.squareSize,{zOrder=-1})
        square.isBox = true
        square.color = {100,100,100,128}
        table.insert(self.squares,square)
        self.count = self.count + 1
      end
    end
  end
end

function Box:clear(c)
  for i=1,#self.squares do
    self.squares[i].color = c
  end
end

function Box:draw()
  g.setColor(0,255,0,255)
  g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Box
