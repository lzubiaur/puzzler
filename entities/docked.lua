-- docked.lua
local Piece = require 'entities.piece'

local Docked = Piece:addState('Docked')

function Docked:enteredState()
  Beholder.trigger('Docked',self)

  Beholder.group(self,function()
    -- Beholder.observe('Selected',self,function() end)
    local moved = false

    Beholder.observe('Moved',self,function(x,y)
      moved = true
      self:moveSquares(x,y)
    end)

    Beholder.observe('Released',self,function(x,y)
      if not moved then
        -- Right rotate the piece
        -- self:rotr()
      else
        self:drop(x,y)
      end
      moved = false
    end)

    Beholder.observe('Cancelled',self,function()
      self:drop(x,y)
      moved = false
    end)
  end)
end

function Docked:exitedState()
  Beholder.stopObserving(self)
end

function Docked:drop(x,y)
  if self:checkCells() < self:getOrder() then
    -- rollback to dock position
    self:moveSquares(self.ox,self.oy)
  else
    -- commit to the current position
    self:moveToCurrentCell()
    self:gotoState('Commited')
  end
end

return Docked
