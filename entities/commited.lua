-- commited.lua
-- Piece is in "Commited" status when it's been inserted in the box

local Piece = require 'entities.piece'

local Commited = Piece:addState('Commited')

function Commited:enteredState()
  Log.debug('Entered state commited')
  Beholder.trigger('Commited',self)
  -- save commited position
  self.cx,self.cy = self.x,self.y
  for i=1,#self.squares do
    self:createEventHandlers(self.squares[i])
  end
end

function Commited:createEventHandlers(target)
  Beholder.group(self,function()
    local count,time,ax,ay = 0,0
    Beholder.observe('Pressed',target,function(x,y)
      ax,ay = self:getLocalPoint(x,y)
      self:setZOrder(1)
      -- double click to remove the piece to the dock pane
      count = count + 1
      if count == 1 then
        time = love.timer.getTime()
      elseif count == 2 then
        local t = love.timer.getTime() - time
        if t < .5 then
          self:dock()
        end
        count = 0
      end
    end)
    Beholder.observe('Moved',target,function(x,y)
      self:moveSquares(x-ax,y-ay)
      count = 0
    end)
    Beholder.observe('Released',target,function(x,y)
      self:setZOrder(0)
      self:drop(x-ax,y-ay)
    end)
    Beholder.observe('Cancelled',target,function()
      self:setZOrder(0)
      self:drop(x-ax,y-ay)
    end)
    Beholder.observe('SaveState',function()
      self:drop(self.x,self.y)
      self:saveState('Commited',{x=self.x,y=self.y})
    end)
  end)
end

function Commited:exitedState()
  Beholder.stopObserving(self)
  Log.debug('Exited state commited')
end

-- TODO destroy
-- function Commited:destroy()
--   Beholder.stopObserving(self)
--   Entity.destroy(self)
-- end

function Commited:dock()
  self:moveSquares(game.pane.x+self.ox,self.oy)
  self:gotoState('Docked')
end

function Commited:drop(x,y)
  local free,taken = self:queryFreeTakenCells()
  if free == 0 and taken == 0 then
    -- Drop outside the box. Move to the orginal position in the pane
    self:dock()
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
