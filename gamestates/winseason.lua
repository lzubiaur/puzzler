local Game   = require 'common.game'
local Entity = require 'entities.entity'
local Play = require 'gamestates.play'

local WinSeason = Game:addState('WinSeason')

function WinSeason:enteredState()
  Log.debug('Entered state WinSeason')
  Beholder.trigger('WinSeason')
  self.swallowTouch = true
  Entity:new(self.world,0,0,conf.width,conf.height,{zOrder=9})
end

-- function WinSeason:update(dt)
--   -- self:updateShaders(dt, self.progress.shift, self.progress.alpha)
-- end

function WinSeason:drawAfterCamera()
  g.setColor(30,30,30,180)
  g.rectangle('fill',0,conf.height/2-30,conf.width,60)
  g.setColor(255,255,255,255)
  g.printf('Thank you for playing Puzzler!',0,conf.height/2-self.fontHeight/2,conf.width,'center')
end

function WinSeason:touchreleased(id, x, y, dx, dy, pressure)
    self:gotoState('Start')
end

function WinSeason:keypressed(key, scancode, isrepeat)
  if key == 'space' or key == 'escape' then
    self:gotoState('Start')
  end
end

return WinSeason
