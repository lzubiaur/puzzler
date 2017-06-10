-- checkpoint.lua

local Entity = require 'entities.entity'

local Checkpoint = Class('Checkpoint', Entity)

function Checkpoint:initialize(world,x,y)
  Entity.initialize(self,world,x,y, conf.cellSize, conf.cellSize, { zOrder = -1 })
  self.alpha = 180
  self.scale = 1
  self.tween = Tween.new(0.3,self,{alpha = 0,scale=2})
  self:observeOnce('Checkpoint',self,function()
    self.touched = true
  end)
end

function Checkpoint:draw()
  local c = { g.getColor() }
  local _r,_g,_b = to_rgb(palette.main)

    g.push()
      local ox,oy = self:getCenter()
      g.setColor(_r,_g,_b,self.alpha)
      g.translate(ox,oy)
      g.scale(self.scale,self.scale)
      g.rectangle('line', -self.w/2,-self.h/2,self.w,self.h)
      g.rectangle('fill', -self.w/2+10,-self.h/2+10,self.w-20,self.h-20)
    g.pop()

  g.setColor(unpack(c))
end

function Checkpoint:update(dt)
  if self.touched and self.tween:update(dt) then
    game:getCurrentLevelState().checkpoint = { self.x, self.y }
    Entity.destroy(self)
  end
end

return Checkpoint
