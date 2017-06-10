-- paused.lua

local Play = require 'gamestates.play'
local Game = require 'common.game'

local Paused = Game:addState('Paused')

function Paused:enteredState()
  Log.info('Entered state Paused')
  -- Pause the gameplay/music...
  -- self.music:pause()
end

function Paused:update(dt)
  -- self:updateShaders(dt)
end

function Paused:keypressed(key, scancode, isrepeat)
  if key == 'p' then
    -- Resume music
    -- self.music:resume()
    self:popState()
  end
end

return Paused
