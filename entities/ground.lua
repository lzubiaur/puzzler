-- ground.lua

local Entity = require 'entities.entity'

local Ground = Class('Ground', Entity)

function Ground:initialize(world,x,y,w,h,opt)
  Entity.initialize(self, world,x,y,w,h,opt)
  -- Use a pattern to fill the ground
  self.ax,self.ay,self.alpha = 0,0,0
  self.img = g.newImage(opt.path)
  self.img:setWrap('repeat','repeat')
  self.quad = g.newQuad(0,0,self.w,self.h,self.img:getWidth(),self.img:getHeight())
  self.tween = Tween.new(1,self,{alpha=255})
  self.coroutine = coroutine.create(function()
    self.tween = nil
    coroutine.yield()
    self.tween = Tween.new(1,self,{alpha=0})
    coroutine.yield()
    self:destroy()
  end)
end

function Ground:fadeOutAndRemove()
  coroutine.resume(self.coroutine)
end

function Ground:update(dt)
  self.ax = self.ax + 10 * dt -- move 10 pixels/second
  self.quad:setViewport(self.ax,self.ay,self.w,self.h)
  if self.tween and self.tween:update(dt) then
    coroutine.resume(self.coroutine)
  end
end

function Ground:draw()
  g.setColor(255,255,255,self.alpha)
  -- Draw the pattern
  g.draw(self.img,self.quad,self.x,self.y)
  -- g.rectangle('fill',self.x,self.y,self.w,self.h)
  -- g.setColor(to_rgb(palette.line))
  -- g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Ground
