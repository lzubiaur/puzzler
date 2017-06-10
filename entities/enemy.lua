-- enemy.lua

local Entity = require 'entities.entity'

local Enemy = Class('Enemy', Entity)

function Enemy:initialize(world,x,y,w,h)
  w = w or conf.cellSize
  h = h or conf.cellSize
  Entity.initialize(self,world,x,y,w,h,{ zOrder = -1 })
end

return Enemy
