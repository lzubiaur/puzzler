-- cell.lua
-- Cell is the square unit of the box entity

local Entity = require 'entities.entity'

local Cell = Class('Cell',Entity)

function Cell:initialize(world,x,y,opt)
  Entity.initialize(self,world,x,y,conf.squareSize,conf.squareSize,opt)
  self.color = { 30,30,30,255 }
end

function Cell:draw()
  g.setColor(unpack(self.color))
  Entity.draw(self)
end

return Cell
