-- button.lua

local Entity = require 'entities.entity'

local Button = Class('Button',Entity):include(Stateful)

function Button:initialize(world, x,y, w,h, opt)
  Entity.initialize(self,world, x,y, w,h, opt)
  opt = opt or {}
  self.text = opt.text or ''
  local onSelected = opt.onSelected or function() end
  self.colors = {
    normal = {255,255,255,255},
    hover = {255,0,0,255},
    selected = {0,255,0,255}
  }
  self.color = self.colors.normal

  Beholder.group(self,function()
    Beholder.observe('Pressed',self,function()
      self.color = self.colors.hover
    end)
    Beholder.observe('Moved',self,function(x,y)
      if not self:containsPoint(x,y) then
        self.color = self.colors.normal
      else
        self.color = self.colors.hover
      end
    end)
    Beholder.observe('Released',self,function(x,y)
      if self:containsPoint(x,y) then
        self.color = self.colors.selected
        onSelected()
      else
        self.color = self.colors.normal
      end
    end)
  end)
end

function Button:draw()
  g.setColor(unpack(self.color))
  g.rectangle('fill',self.x,self.y,self.w,self.h,10)
  g.setColor(0,0,0,255)
  local h = g.getFont():getHeight()/2
  g.printf(self.text,self.x,self.y+self.h/2-h,self.w,'center')
end

return Button
