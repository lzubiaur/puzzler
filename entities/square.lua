-- square
local Entity = require 'entities.entity'

local Square = Class('Square',Entity)

function Square:initialize(world,x,y,opt)
  Entity.initialize(self,world,x,y,conf.squareSize,conf.squareSize,opt)
end

function Square:draw()
  g.setColor(unpack(self.color))
  Entity.draw(self)
end

return Square
