-- follow.lua

local Entity = require 'entities.entity'

local Follow = Class('Follow',Entity)

function Follow:initialize(world,x,y)
  Entity.initialize(self,world,x,y,1,1,{zOrder = 100})
end

function Follow:pan(x,y,seconds,ease)
  self.tween = Tween.new(seconds,self,{x=x,y=y},ease)
end

function Follow:update(dt)
  if self.tween then
    self.tween:update(dt)
  end
end

function Follow:draw()
  local ps = g.getPointSize()
  g.setColor(0,255,0,255)
  g.setPointSize(5)
  g.points(self.x,self.y)
  g.setPointSize(ps)
end

return Follow
