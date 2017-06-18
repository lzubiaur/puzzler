-- commited.lua
-- Piece is in "Commited" status when it's been inserted in the box

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
  local free,taken = self:queryFreeTakenCells()
  if free == 0 and taken == 0 then
    -- Drop outside the box. Move to the orginal position in the pane
    self:moveSquares(game.pane.x+self.ox,self.oy)
    self:gotoState('Docked')
  elseif free < self:getOrder() or taken > 0 then
    -- Not enough space or is not free. Rollback to the previous position
    self:moveSquares(self.cx,self.cy)
  else
    -- Commit the current position
    self:moveToCurrentCell()
    self.cx,self.cy = self.x,self.y
  end

end

return Commited
