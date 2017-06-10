-- loading.lua

local Game = require 'common.game'

local Loading = Game:addState('Loading')

local finishLoading = false

local assets = {
  start = {
    font = {
      path = 'resources/fonts/pzim3x5.fnt', image = 'resources/fonts/pzim3x5.png'
    }
  },
  level1 = {
    map = 'resources/maps/map01.lua',
    music = 'resources/music/keygen_9000.xm',
  },
  level2 = {
    map = 'resources/maps/map02.lua',
    music = 'resources/music/keygen_9000.xm',
  }
}

function Loading:enteredState()
  Log.info('Entered state Loading...')

  assert(self.nextState ~= nil, 'Next state not defined')

  finishLoading = false

  if self.nextState == 'Start' then
    Loader.newBMFont(self,'font',assets.start.font.image,assets.start.font.path)
  elseif self.nextState == 'Play' then
    Loader.newSource(self,'music',assets.level1.music,'stream')
  else
    error('Unknown next state: '..self.nextState)
  end

  Loader.start(function() finishLoading = true end)
end

function Loading:draw()
  local percent = 0
  if Loader.resourceCount ~= 0 then
    percent = Loader.loadedCount / Loader.resourceCount
  end
  g.print(("Loading .. %d%%"):format(percent*100), 100, 100)
end

function Loading:update(dt)
  if not finishLoading then
    Loader.update()
  else
    Log.info('Loading done.')
    self:gotoState(self.nextState)
  end
end

return Loading
