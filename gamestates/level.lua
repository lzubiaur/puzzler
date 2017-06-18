-- level.lua

local Game = require 'common.game'
local Play = require 'gamestates.play'

local Level = Game:addState('Level')

function Level:enteredState()
  Log.info('Entered state "Level"')
end

function Level:exitedState()
  Log.info('Existed state "Level"')
end

function Level:pausedState()
  Log.info('Paused state "Level"')
end

function Level:continuedState()
  Log.info('Continued state "Level"')
end

function Level:pushedState()
  Log.info('Pushed state "Level"')
end

function Level:poppedState()
  Log.info('Popped state "Level"')
end

function Level:mousereleased(x, y, button, istouch)
  self:pushState('POC')
end

function Level:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    self:gotoState('Start')
  elseif key == 'p' then
    self:pushState('Paused')
  elseif key == 'd' then
    self:pushState('POC')
  elseif key == 's' then
  end
end

return Level
