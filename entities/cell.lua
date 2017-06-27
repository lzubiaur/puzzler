-- cell.lua
-- Cell is the square unit of the box entity

local Entity = require 'entities.entity'

local Cell = Class('Cell',Entity)

function Cell:initialize(world,x,y,opt)
  Entity.initialize(self,world,x,y,conf.squareSize,conf.squareSize,opt)
end

function Cell:draw()
  g.setColor(to_rgb(palette.base))
  g.rectangle('fill',self.x,self.y,self.w,self.h)
  -- g.setColor(255,255,255,128)
  -- g.rectangle('line',self.x+.5,self.y+.5,self.w-1,self.h-1)
end

return Cell
