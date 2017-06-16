-- pane.lua

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
  Beholder.observe('Moved',self,function(x,y,dx,dy)
    if dy < 1 then
      for i=1,len do
        local p = pieces[i]
        p:moveSquares(p.x+dx,p.y)
      end
    end
  end)
end

function Pane:draw()
  g.setColor(0,255,0,255)
  g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Pane
