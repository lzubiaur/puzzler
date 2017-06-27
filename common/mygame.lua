-- mygame.lua
-- Add custom functionalities that are useful the other game states
local Game = require 'common.game'
local Ground = require 'entities.ground'

local MyGame = Class('MyGame',Game)

function MyGame:initialize()
  Game.initialize(self)
end

function MyGame:newBackground()
  if not self.state.patternId then
    self.state.patternId = 1
  elseif self.state.patternId < 14 then
    self.state.patternId = self.state.patternId + 1
  else
    self.state.patternId = 1
  end
  local filename = string.format('resources/img/patterns/pattern%02d.png',self.state.patternId)
  Log.info('Pattern',filename)
  local ground = Ground:new(self.world,0,0,conf.width,conf.height,{path=filename,zOrder=-5})
  Timer.after(30,function()
    ground:fadeOutAndRemove()
    self:newBackground()
  end)
end

return MyGame
