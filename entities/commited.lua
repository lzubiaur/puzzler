-- commited.lua

local Piece = require 'entities.piece'

local Commited = Piece:addState('Commited')

function Commited:enteredState()
  -- save commited position
  self.co,self.cy = self.x,self.y
end

function Commited:exitedState()
end

function Commited:move(x,y)
  self:moveSquares(x,y)
end

function Commited:drop(x,y)
  if self:checkCells() < self:getOrder() then
    self:moveSquares(self.co,self.cy)
  else
    self:moveToCurrentCell()
    self.co,self.cy = self.x,self.y
  end

end

return Commited
