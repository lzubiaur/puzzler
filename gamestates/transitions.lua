-- transitions.lua

local Game = require 'common.game'

-- GameplayIn

local GameplayIn = Game:addState('GameplayIn')

function GameplayIn:enteredState()
  Log.info 'Enter state GameplayIn'

  -- Call the garbage collector before starting the level
  Log.debug('Before gc (MB)',collectgarbage("count")/1024)
  collectgarbage('collect')
  Log.debug('After gc (MB)',collectgarbage("count")/1024)

  self.progress.tween:reset()
end

function GameplayIn:exitedState()
  Log.info 'Exited state GameplayIn'
end

function GameplayIn:update(dt)
  if self.progress.tween:update(dt) then
    self:popState()
  end
  -- Do transition effects (music/screen fade in)
end

function GameplayIn:keypressed(key, scancode, isRepeat)
  -- touche disabled
end

-- GameplayOut

local GameplayOut = Game:addState('GameplayOut')

function GameplayOut:enteredState()
  Log.info 'Enter state GameplayOut'
  -- running backwards
  self.progress.tween:set(self.progress.duration)
end

function GameplayOut:exitedState()
  Log.info 'Exited state GameplayOut'
end

function GameplayOut:update(dt)
  if self.progress.tween:update(-dt) then
    self:popState()
    Beholder.trigger('ResetGame')
  end
end

function GameplayOut:onGameOver()
  Log.info('Received gameover. Ignored.')
end

function GameplayOut:keypressed(key, scancode, isRepeat)
  -- disable touches
end
