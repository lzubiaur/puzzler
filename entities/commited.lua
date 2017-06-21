-- commited.lua
-- Piece is in "Commited" status when it's been inserted in the box

local Piece = require 'entities.piece'

local Commited = Piece:addState('Commited')

function Commited:enteredState()
  Beholder.trigger('Commited',self)
  -- save commited position
  self.cx,self.cy = self.x,self.y
  local count,time = 0,0
  Beholder.group(self,function()
    Beholder.observe('Selected',self,function()
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

    Beholder.observe('Moved',self,function(x,y)
      self:moveSquares(x,y)
      count = 0
    end)

    Beholder.observe('Released',self,function(x,y)
      self:setZOrder(0)
      self:drop(x,y)
    end)

    Beholder.observe('Cancelled',self,function()
      self:setZOrder(0)
      self:drop(x,y)
    end)

    Beholder.observe('SaveState',function()
      self:drop(self.x,self.y)
      self:saveState('Commited',{x=self.x,y=self.y})
    end)
  end)
end

function Commited:exitedState()
  Beholder.stopObserving(self)
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
