-- button.lua

local Entity = require 'entities.entity'

local Button = Class('Button',Entity):include(Stateful)

function Button:initialize(world,x,y,w,h,f,opt)
  Entity.initialize(self,world,x,y,w,h,opt)
  self.text = opt.text or 'text'
  self.color = {255,255,255,255}

  Beholder.group(self,function()
    Beholder.observe('Pressed',self,function()
      self.color = {255,0,0,255}
    end)
    Beholder.observe('Moved',self,function(x,y)
      if not self:containsPoint(x,y) then
        self.color = {255,255,255,255}
      else
        self.color = {255,0,0,255}
      end
    end)
    Beholder.observe('Released',self,function(x,y)
      if self:containsPoint(x,y) then
        f()
      end
      self.color = {255,255,255,255}
    end)
  end)
end

function Button:draw()
  g.setColor(unpack(self.color))
  g.rectangle('fill',self.x,self.y,self.w,self.h,10)
  g.setColor(0,0,0,255)
  g.printf(self.text,self.x,self.y,self.w,'center')
end

return Button
