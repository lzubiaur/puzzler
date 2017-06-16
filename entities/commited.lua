-- commited.lua
local Piece = require 'entities.piece'

local Commited = Piece:addState('Commited')

function Commited:enteredState()
  Beholder.trigger('Commited',self)
  -- save commited position
  self.cx,self.cy = self.x,self.y
  Beholder.group(self,function()
    Beholder.observe('Moved',self,function(x,y)
      self:moveSquares(x,y)
    end)

    Beholder.observe('Released',self,function(x,y)
      self:drop(x,y)
    end)

    Beholder.observe('Cancelled',self,function()
      self:drop(x,y)
    end)
  end)
end

function Commited:exitedState()
  Beholder.stopObserving(self)
end

function Commited:drop(x,y)
  local free,taken = self:checkCells()
  if free == 0 and taken == 0 then
    -- drop outside the box
    self:moveSquares(self.ox,self.oy)
    self:gotoState('Docked')
  elseif free < self:getOrder() or taken > 0 then
    self:moveSquares(self.cx,self.cy)
  else
    self:moveToCurrentCell()
    self.cx,self.cy = self.x,self.y
  end

end

return Commited
