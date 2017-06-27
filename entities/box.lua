-- box.lua
-- Box is the factory and container of cell entities.

local Entity = require 'entities.entity'
local Cell = require 'entities.cell'

local Box = Class('Box',Entity)

function Box:initialize(world,x,y,t)
  local w,h = 0,#t
  self.cells = {}
  for i=1,h do
    local rowWidth = #t[i]
    for j=1,rowWidth do
      if t[i][j] ~= '_' then
        local cell = Cell:new(world,x+(j-1)*conf.squareSize,y+(i-1)*conf.squareSize,{zOrder=-3})
        table.insert(self.cells,cell)
      end
    end
    w = math.max(w,rowWidth)
  end
  Entity.initialize(self,world,x,y,w*conf.squareSize,h*conf.squareSize,{zOrder=-4})
end

function Box:draw()
  g.setColor(to_rgb(palette.text))
  for _,c in ipairs(self.cells) do
    g.rectangle('fill',c.x-2,c.y-2,c.w+4,c.h+4)
  end
  -- Debug draw
  -- g.setColor(0,255,0,255)
  -- g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Box
