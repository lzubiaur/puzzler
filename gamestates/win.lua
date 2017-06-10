local Game   = require 'common.game'
local Play = require 'gamestates.play'

local Win = Game:addState('Win')

function Win:enteredState()
  Log.debug('Entered state Win')
  -- reset the level checkpoint
  self:getCurrentLevelState().checkpoint = nil
end

function Win:update(dt)
  self:updateShaders(dt, self.progress.shift, self.progress.alpha)
end

function Win:drawWorld(l,t,w,h)
  Play.drawWorld(self,l,t,w,h)
  -- g.setColor(255,255,255,255)
  g.printf('Thank you',l,t+50,conf.width,'center')
  g.printf('for playing',l,t+100,conf.width,'center')
  g.printf('PULSE lite!',l,t+150,conf.width,'center')
end

function Win:touchreleased(id, x, y, dx, dy, pressure)
  self:gotoState('Start')
end

function Win:keypressed(key, scancode, isrepeat)
  if key == 'space' then
    self:gotoState('Start')
  end
end

return Win
