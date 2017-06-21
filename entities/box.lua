-- box.lua
-- Box is the factory and container of cell entities.

local Entity = require 'entities.entity'
local Cell = require 'entities.cell'

local Box = Class('Box',Entity)

function Box:initialize(world,x,y,t)
  local w,h = 0,#t
  for i=1,h do
    local rowWidth = #t[i]
    for j=1,rowWidth do
      if t[i][j] ~= '_' then
        Cell:new(world,x+(j-1)*conf.squareSize,y+(i-1)*conf.squareSize,{zOrder=-3})
      end
    end
    w = math.max(w,rowWidth)
  end
  Entity.initialize(self,world,x,y,w*conf.squareSize,h*conf.squareSize)
end

function Box:draw()
  -- Debug draw
  -- g.setColor(0,255,0,255)
  -- g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Box
