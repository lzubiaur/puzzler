-- level.lua

local Game = require 'common.game'
local Play = require 'gamestates.play'

local Level = Game:addState('Level')

function Level:enteredState()
end

function Level:exitedState()
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
