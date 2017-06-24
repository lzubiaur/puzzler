local Game   = require 'common.game'
local Play = require 'gamestates.play'

local WinSeason = Game:addState('WinSeason')

function WinSeason:enteredState()
  Log.debug('Entered state WinSeason')
  -- reset the level checkpoint
  self:getCurrentLevelState().checkpoint = nil
end

function WinSeason:update(dt)
  -- self:updateShaders(dt, self.progress.shift, self.progress.alpha)
end

function WinSeason:drawAfterCamera()
  -- g.setColor(255,255,255,255)
  g.print('Win whole season!',200,200)
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
