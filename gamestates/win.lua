local Game = require 'common.game'
local Entity = require 'entities.entity'
local Play = require 'gamestates.play'

local Win = Game:addState('Win')

function Win:enteredState()
  Log.debug('Entered state Win')
  Beholder.trigger('Win')
  self.swallowTouch = true
  Entity:new(self.world,0,0,conf.width,conf.height,{zOrder=9})
  -- reset the level checkpoint
  -- self:getCurrentLevelState().checkpoint = nil
end

-- function Win:update(dt)
--   self:updateShaders(dt, self.progress.shift, self.progress.alpha)
-- end

function Win:drawAfterCamera()
  g.setColor(30,30,30,180)
  g.rectangle('fill',0,conf.height/2-30,conf.width,60)
  g.setColor(255,255,255,255)
  g.printf('Cleared!',0,conf.height/2-self.fontHeight/2,conf.width,'center')
end

function Win:touchreleased(id, x, y, dx, dy, pressure)
  -- self:gotoState('Play')
end

function Win:keypressed(key, scancode, isrepeat)
  if key == 'space' or key == 'escape' then
    self:gotoState('Play')
  end
end

return Win
