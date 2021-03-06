-- pane.lua
-- Simple entity to group the "docked" pieces and move them horizontally

local Entity = require 'entities.entity'

local Pane = Class('Pane',Entity)

function Pane:initialize(world,x,y,w,h)
  Entity.initialize(self,world,x,y,w,h,{zOrder=-4})

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
    self:scroll(pieces,len,conf.squareSize*2)
  end)
  Beholder.observe('PaneScrollRight',function()
    self:scroll(pieces,len,-conf.squareSize*2)
  end)
end

function Pane:scroll(pieces,len,dx)
  local ax = self.x + self.w
  if self.x > 0 or ax < conf.width then return end
  if self.x + dx > 0 then
    dx = math.abs(self.x)
    Beholder.trigger('ScrolledTopRight')
  elseif ax + dx < conf.width then
    dx = conf.width - ax
    Beholder.trigger('ScrolledTopLeft')
  end
  -- if self.x+dx > 0 or self.x+self.w+dx < game:toWorld(conf.width) then return end
  for i=1,len do
    local p = pieces[i]
    p:moveSquares(p.x+dx,p.y)
  end
  self:teleport(self.x+dx,self.y)
end

function Pane:draw()
  -- g.setColor(to_rgb(palette.base,128))
  -- g.rectangle('fill',self.x-2,self.y-2,self.w+4,self.h+4)
end

return Pane
