-- ground.lua

local Entity = require 'entities.entity'

local Ground = Class('Ground', Entity)

function Ground:initialize(world,x,y,w,h,opt)
  Entity.initialize(self, world,x,y,w,h,opt)
  -- Use a pattern to fill the ground
  self.img = g.newImage('resources/pattern.png')
  self.img:setWrap('repeat','repeat')
  self.quad = g.newQuad(0,0,self.w,self.h,self.img:getWidth(),self.img:getHeight())
end

local x,y = 0,0
function Ground:update(dt)
  x = x + 10 * dt
  self.quad:setViewport(x,y,self.w,self.h)
end

function Ground:draw()
  -- g.setColor(to_rgb(palette.fill))
  -- Draw the pattern
  g.draw(self.img,self.quad,self.x,self.y)
  -- g.rectangle('fill',self.x,self.y,self.w,self.h)
  -- g.setColor(to_rgb(palette.line))
  -- g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Ground
