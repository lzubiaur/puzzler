-- docked.lua
local Piece = require 'entities.piece'

local Docked = Piece:addState('Docked')

function Docked:enteredState()
  Beholder.observe('Selected',self,function() end)
  Beholder.observe('Moved',self,function(x,y) self:move(x,y) end)
  Beholder.observe('Released',self,function(x,y) self:drop(x,y) end)
  self.idRotr = Beholder.observe('Right',function() self:rotr() end)
end

function Docked:exitedState()
  Log.debug('Exited state "Docked"')
  Beholder.stopObserving(self.idRotr)
end

function Docked:move(x,y)
  self:moveSquares(x,y)
end

function Docked:drop(x,y)
  if self:checkCells() < self:getOrder() then
    -- rollback to dock position
    self:moveSquares(self.ox,self.oy)
  else
    -- commit to the current position
    self:moveToCurrentCell()
    Beholder.trigger('Commit')
    self:gotoState('Commited')
  end
end

function Docked:moveAndQuery(x,y)
end

return Docked
