-- start.lua

local Game = require 'common.game'
local Entity = require 'entities.entity'
local Button = require 'entities.ui.button'
local ImageButton = require 'entities.ui.imagebutton'
local Ground = require 'entities.ground'

local Start = Game:addState('Start')

function Start:enteredState()
  Log.info('Entered the state "Start"')

  Timer.clear()

  self.world = Bump.newWorld(conf.cellSize)

  self:createCamera(conf.width,conf.height)

  self:newGround()

  local font = love.graphics.newFont('resources/fonts/Boogaloo-Regular.ttf',32)
  love.graphics.setFont(font)

  Button:new(self.world,conf.width/2-100,30,200,40,{
    onSelected = function()
      self:gotoState('Play')
    end,
    text='Play!',
    color = { Lume.color('#de5a4c',255) },
    textColor = { Lume.color('#fef8d7',255) },
  })

  Button:new(self.world,conf.width/2-100,80,200,40,{
    onSelected = function()
      if love.system.getOS() == 'Android' then
        love.system.openURL('https://play.google.com/store/apps/dev?id=7240016677312552672')
      end
    end ,
    text='More games',
    color = { Lume.color('#77769e',255) },
    textColor = { Lume.color('#fef8d7',255) },
  })
  -- Rate app
  ImageButton:new(self.world,conf.width/2-100,130,{
    path = 'resources/img/commenting-o.png',
    onSelected = function()
      if love.system.getOS() == 'Android' then
        love.system.openURL('https://play.google.com/store/apps/details?id=com.voodoocactus.games')
      end
    end,
    color = { Lume.color('#77769e',255) },
  })
  -- Quit app
  ImageButton:new(self.world,0,0,{
    path = 'resources/img/arrow-left.png',
    onSelected = function()
      love.event.push('quit')
    end,
    color = { Lume.color('#77769e',255) },
  })

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

function Start:newGround()
  if not self.state.patternId then
    self.state.patternId = 1
  elseif self.state.patternId < 15 then
    self.state.patternId = self.state.patternId + 1
  else
    self.state.patternId = 1
  end
  local filename = string.format('resources/img/patterns/pattern%02d.png',self.state.patternId)
  Log.info('Pattern',filename)
  local ground = Ground:new(self.world,0,0,conf.width,conf.height,{path=filename,zOrder=-5})
  Timer.after(5,function()
    ground:fadeOutAndRemove()
    self:newGround()
  end)
end

function Start:drawEntities(l,t,w,h)
    -- Only draw only visible entities
    local items,len = self.world:queryRect(l,t,w,h)
    table.sort(items,Entity.sortByZOrder)
    Lume.each(items,'draw')
end

function Start:draw()
  Push:start()
    g.setColor(to_rgb(palette.text))
    g.clear(to_rgb(palette.bg))

    self.camera:draw(function(l,t,w,h)
      self:drawEntities(l,t,w,h) -- Call a function so it can be override by other state
    end)

  Push:finish()
end

-- Update visible entities
function Start:updateEntities(dt)
  -- TODO add a padding parameter to update outside the visible windows
  local l,t,h,w = self.camera:getVisible()
  local items,len = self.world:queryRect(l,t,w,h)
  Lume.each(items,'update',dt)
end

function Start:update(dt)
  Timer.update(dt)
  self:updateEntities(dt)
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

return Start
