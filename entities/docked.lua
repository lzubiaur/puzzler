-- docked.lua
local Piece = require 'entities.piece'

local Docked = Piece:addState('Docked')

function Docked:enteredState()
  Beholder.observe('Selected',self,function() end)
  Beholder.observe('Moved',self,function(x,y) self:move(x,y) end)
  Beholder.observe('Released',self,function(x,y) self:drop(x,y) end)
end

function Docked:exitedStated()
end

function Docked:move(x,y)
  self:moveSquares(x,y)
end

function Docked:drop(x,y)
  local dx,dy,c = self.x-x,self.y-y,0
  for i=1,#self.squares do
    local s = self.squares[i]
    local cx,cy = s:getCenter()
    local items,len = self.world:queryPoint(cx,cy,function(item)
      return item.class.name == 'Square' and item ~= s
    end)
    if len == 1 and items[1].isBox then
      c = c +1
    end
  end
  if c < self:getOrder() then
    self:moveSquares(self.ox,self.oy)
  end
end

function Docked:moveAndQuery(x,y)
end

return Docked
