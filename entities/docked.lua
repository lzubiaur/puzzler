-- docked.lua
-- A piece is in the "Docked" status when it's in the dock pane.

local Piece = require 'entities.piece'

local Docked = Piece:addState('Docked')

function Docked:enteredState()
  Beholder.trigger('Docked',self)

  Beholder.group(self,function()
    local first,moving = true,nil

    Beholder.observe('Moved',self,function(x,y,dx,dy)
      if first then
        -- TODO use a relative max dy
        moving = dy > 5
        first = false
      end
      if moving then
        self:moveSquares(x,y)
      end
    end)

    Beholder.observe('Released',self,function(x,y)
      if moving then
        self:drop(x,y)
      end
      first = true
    end)

    Beholder.observe('Cancelled',self,function()
      if moving then
        self:drop(x,y)
      end
      first = true
    end)
  end)
end

function Docked:exitedState()
  Beholder.stopObserving(self)
end

function Docked:drop(x,y)
  if self:queryFreeTakenCells() < self:getOrder() then
    -- rollback to dock position
    self:moveSquares(game.pane.x + self.ox,self.oy)
  else
    -- commit to the current position
    self:moveToCurrentCell()
    self:gotoState('Commited')
  end
end

return Docked
