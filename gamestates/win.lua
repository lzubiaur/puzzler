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

function Win:drawAfterCamera()
  -- g.setColor(255,255,255,255)
  g.print('Win',200,200)
end

function Win:touchreleased(id, x, y, dx, dy, pressure)
  self:gotoState('Start')
end

function Win:keypressed(key, scancode, isrepeat)
  if key == 'space' or key == 'escape' then
    self:gotoState('Start')
  end
end

return Win
