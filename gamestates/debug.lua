-- debug.lua

local Game = require 'common.game'
local Level = require 'gamestates.level'

local Debug = Game:addState('Debug')

local _text = {}

function Debug.d(id,format,...)
  _text[id] = format and string.format(format,...) or nil
end

function Debug:enteredState()
  self.font = g.newFont('resources/fonts/roboto-condensed.fnt','resources/fonts/roboto-condensed.png')
  self.fontHeight = self.font:getHeight()
end

function Debug:updateGridInfo()
  local mx,my = 0,0
  if love.mouse then
    mx,my = Push:toGame(love.mouse.getPosition())
  elseif love.touch then
    local touches = love.touch.getTouches()
    if #touches > 0 then
      mx,my = love.touch.getPosition(touches[1])
    end
  end
  local oScreenx, oScreeny = self.camera:toScreen(0, 0)
  local mWorldx, mWorldy = self.camera:toWorld(mx, my)
  local camx, camy = self.camera:getPosition()
  local scale = self.camera:getScale()
  local cx, cy = self.grid:convertCoords("screen","cell", mx, my)
  Debug.d('cam','Camera position: %.3f,%3f',camx,camy)
  Debug.d('scale','Camera zoom: %.3f',scale)
  Debug.d('mouse','Mouse position on Grid: %.3f %.3f',mWorldx,mWorldy)
  Debug.d('cell','Cell coordinate under mouse: %.0f,%.0f',cx,cy)
  Debug.d('screen','Grid origin position on screen: %.3f,%.3f',oScreenx,oScreeny)
end

function Debug:updateInfo()
  Debug.d('fps','FPS: %3f. Average frame time: %.3f ms',love.timer.getFPS(),1000 * love.timer.getAverageDelta())
end

function Debug:drawBeforeCamera()
  self:updateGridInfo()
  self:updateInfo()
  self.grid:draw()
  local font = g.getFont()
  g.setFont(self.font)
  local y = 0
  for _,s in pairs(_text) do
    g.print(s,0,y)
    y = y + self.fontHeight
  end
  g.setFont(font)
end

function Debug:drawAfterCamera()
  g.setColor(255,255,255,255)
  g.print({
    {to_rgb(palette.text)}, 'Esc: quit\n',
  }, conf.width*.5,conf.height*.5)
end

function Debug:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    self:popState()
  elseif key == 'd' then
    -- disable d
  else
    Level.keypressed(self,key,scancode,isrepeat)
  end
end

return Debug
