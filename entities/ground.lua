-- ground.lua

local Entity = require 'entities.entity'

local Ground = Class('Ground', Entity)

function Ground:initialize(world,x,y,w,h)
  Entity.initialize(self, world,x,y,w,h)
  -- Use a pattern to fill the ground
  -- self.img = g.newImage('resources/pattern.png')
  -- self.img:setWrap('repeat','repeat')
  -- self.quad = g.newQuad(0,0,self.w,self.h,self.img:getWidth(),self.img:getHeight())
end

function Ground:draw()
  g.setColor(to_rgb(palette.fill))
  -- Draw the pattern
  -- g.draw(self.img,self.quad,self.x,self.y)
  g.rectangle('fill',self.x,self.y,self.w,self.h)
  g.setColor(to_rgb(palette.line))
  g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Ground
