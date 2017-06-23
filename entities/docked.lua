-- docked.lua
-- A piece is in the "Docked" status when it's in the dock pane.

local Piece = require 'entities.piece'

local Docked = Piece:addState('Docked')

function Docked:enteredState()
  Log.debug('Entered state docked')
  Beholder.trigger('Docked',self)
  for i=1,#self.squares do
    self:createEventHandlers(self.squares[i])
  end
  Beholder.group(self,function()
    Beholder.observe('SaveState',function()
      self:removeState()
    end)
  end)
end

function Docked:createEventHandlers(target)
  Beholder.group(self,function()
    local first,moving = true,nil
    local ax,ay
    Beholder.observe('Pressed',target,function(x,y)
      ax,ay = self:getLocalPoint(x,y)
      self:setZOrder(1)
    end)
    Beholder.observe('Moved',target,function(x,y,dx,dy)
      if first then
        -- XXX use a relative max dy
        moving = dy < 0
        first = false
      end
      if moving then
        self:moveSquares(x-ax,y-ay)
      end
    end)
    Beholder.observe('Released',target,function(x,y,dx,dy)
      self:setZOrder(0)
      if moving then
        self:drop(x-ax,y-ay)
      end
      first = true
    end)
    Beholder.observe('Cancelled',target,function()
      self:setZOrder(0)
      if moving then
        self:drop(x-ax,y-ay)
      end
      first = true
    end)
  end)
end

function Docked:exitedState()
  Beholder.stopObserving(self)
  Log.debug('Exited state docked')
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
