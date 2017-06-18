-- pane.lua
-- Simple entity to group the "docked" pieces and move them horizontally

local Entity = require 'entities.entity'

local Pane = Class('Pane',Entity)

function Pane:initialize(world,x,y,w,h)
  Entity.initialize(self,world,x,y,w,h)

  local pieces,len = {},0
  Beholder.observe('Selected',self,function(x,y)
    pieces,len = self.world:queryRect(self.x,self.y,self.w,self.h,function(item)
      return item.class.name == 'Piece'
    end)
  end)

  local first,moving = true

  Beholder.observe('Moved',self,function(x,y,dx,dy)
    if first then
      -- moving = dy == 0
      moving = dy < 5
      first = false
    end
    if moving then
      if self.x+dx > 0 or self.x+self.w+dx < game:toWorld(conf.width) then return end
      for i=1,len do
        local p = pieces[i]
        p:moveSquares(p.x+dx,p.y)
      end
      self:teleport(self.x+dx,self.y)
    end
  end)

  Beholder.observe('Released',self,function()
    first = true
  end)

  Beholder.observe('Cancelled',self,function()
    first = true
  end)
end

function Pane:draw()
  g.setColor(0,255,0,255)
  g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Pane
