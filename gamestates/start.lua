-- start.lua

local Game = require 'common.game'

local Start = Game:addState('Start')

function Start:enteredState()
  Log.info('Entered the state "Start"')

  love.graphics.setNewFont(18)

  self.progress = {
    -- Add transition parameters here
    alpha = 1,
    dir = 1, -- tween directions (1: forewards, 2:backwards)
    duration = 1,
  }

  self.progress.tween = Tween.new(
  self.progress.duration,
  self.progress,
  { alpha = 1 },
  'inOutCubic')
end

function Start:draw()
  Push:start()
    g.clear(to_rgb(palette.bg))
    g.print([[Esc: quit
Space: play]])
  Push:finish()
end

function Start:update(dt)
  -- self:updateShaders(dt)
end

function Start:keypressed(key, scancode, isRepeat)
  if not self.touchEnabled and isRepeat then return end
  if key == 'space' then
    self:gotoState('Play')
  -- On Android the back button is mapped to the 'escape' key
  elseif key == 'escape' then
    love.event.push('quit')
  end
end

function Start:touchreleased()
  self:gotoState('Play')
end

return Start
