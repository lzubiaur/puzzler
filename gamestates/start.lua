-- start.lua

local Game = require 'common.game'
local Entity = require 'entities.entity'
local Button = require 'entities.ui.button'
local ImageButton = require 'entities.ui.imagebutton'

local Start = Game:addState('Start')

function Start:enteredState()
  Log.info('Entered the state "Start"')

  self.world = Bump.newWorld(conf.cellSize)

  self:createCamera(conf.width,conf.height)

  Button:new(self.world,conf.width/2-100,30,200,40,{
    onSelected = function()
      self:gotoState('Play')
    end,
    text='Play'
  })

  Button:new(self.world,conf.width/2-100,80,200,40,{
    onSelected = function()
      if love.system.getOS() == 'Android' then
        love.system.openURL('https://play.google.com/store/apps/dev?id=7240016677312552672')
      end
    end,
    text='More games'
  })
  -- Rate app
  ImageButton:new(self.world,conf.width/2-100,130,{
    path = 'resources/img/commenting-o.png',
    onSelected = function()
      if love.system.getOS() == 'Android' then
        love.system.openURL('https://play.google.com/store/apps/details?id=com.voodoocactus.games')
      end
    end
  })
  -- Quit app
  ImageButton:new(self.world,0,0,{
    path = 'resources/img/arrow-left.png',
    onSelected = function()
      love.event.push('quit')
    end
  })

  love.graphics.newFont('resources/fonts/Righteous-Regular.ttf',18)
  self.img = love.graphics.newImage('resources/img/start-bg.png')

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

    g.setColor(255,255,255,255)
    g.draw(self.img,0,conf.height-self.img:getHeight())

    self.camera:draw(function(l,t,w,h)
      self:drawEntities(l,t,w,h) -- Call a function so it can be override by other state
    end)

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

return Start
