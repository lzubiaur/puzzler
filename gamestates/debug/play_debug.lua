local Game = require 'common.game'
local Play = require 'gamestates.play'

local debugInfo = {
  'd: toogle debug mode',
  's: toogle step-by-step mode',
  'n: next step',
  'c: switch palette',
}

local PlayDebug = Game:addState('PlayDebug')

function PlayDebug:enteredState()
  Log.info('Entered state PlayDebug')
  Debug.setEnabled(true)
  self.nextStep = false
  self.step = false
end

function PlayDebug:draw()
  Play.draw(self)
  Debug.push()
  Debug.draw()
  local y = 0
  for _,l in ipairs(debugInfo) do
    g.print(l,400,y)
    y = y + 12
  end
  Debug.pop()
end

function PlayDebug:update(dt)
  if self.step and self.nextStep then return end
  Debug.update('fps',love.timer.getFPS())
  Debug.update('Frame',string.format("Average frame time: %.3f ms", 1000 * love.timer.getAverageDelta()))
  -- Debug.update('Music',self.music:tell())
  Play.update(self,dt)
  if self.step then
    self.nextStep = not self.nextStep
  end
end

function PlayDebug:keypressed(key, scancode, isrepeat)
  if key == 'd' then
    self:popState()
  elseif key == 'c' then
    offsetHuePalette(conf.hueOffset)
  elseif key == 's' then
    self.step = not self.step
  elseif self.step and key == 'n' then
    self.nextStep = not self.nextStep
  else
    Play.keypressed(self,key,scancode,isrepeat)
  end
end
