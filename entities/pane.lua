-- pane.lua
-- Simple entity to group the "docked" pieces and move them horizontally

local Entity = require 'entities.entity'

local Pane = Class('Pane',Entity)

function Pane:initialize(world,x,y,w,h)
  Entity.initialize(self,world,x,y,w,h,{zOrder=-1})

  local pieces,len = {},0
  Beholder.observe('Pressed',self,function(x,y)
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
      self:scroll(pieces,len,dx)
    end
  end)

  Beholder.observe('Released',self,function()
    first = true
  end)

  Beholder.observe('Cancelled',self,function()
    first = true
  end)

  Beholder.observe('PaneScrollLeft',function()
    self:scroll(pieces,len,-conf.squareSize*2)
  end)
  Beholder.observe('PaneScrollRight',function()
    self:scroll(pieces,len,conf.squareSize*2)
  end)
end

function Pane:scroll(pieces,len,dx)
  if self.x + dx > 0 then
    dx = math.abs(self.x)
  elseif self.x + self.w + dx < game:toWorld(conf.width) then
    dx = conf.width - (self.x + self.w)
  end
  -- if self.x+dx > 0 or self.x+self.w+dx < game:toWorld(conf.width) then return end
  for i=1,len do
    local p = pieces[i]
    p:moveSquares(p.x+dx,p.y)
  end
  self:teleport(self.x+dx,self.y)
end

function Pane:draw()
  -- g.setColor(0,255,0,255)
  -- g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Pane
