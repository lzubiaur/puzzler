-- start.lua

local Game = require 'common.game'
local Entity = require 'entities.entity'
local Button = require 'entities.ui.button'
local ImageButton = require 'entities.ui.imagebutton'

local Start = Game:addState('Start')

function Start:enteredState()
  Log.info('Entered the state "Start"')

  Timer.clear()

  self.world = Bump.newWorld(conf.cellSize)
  self:createCamera(conf.width,conf.height)
  self:newBackground()
  self.logo = g.newImage('resources/img/logo.png')

  local font = love.graphics.newFont('resources/fonts/Boogaloo-Regular.ttf',32)
  self.fontHeight = font:getHeight()
  love.graphics.setFont(font)

  Button:new(self.world,conf.width/2-100,160,200,40,{
    onSelected = function()
      self:gotoState('Play')
    end,
    text='Play!',
    color = { Lume.color('#de5a4c',255) },
    textColor = { Lume.color('#fef8d7',255) },
  })
  Button:new(self.world,conf.width/2-100,220,200,40,{
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
  ImageButton:new(self.world,conf.width/2-69,280,{
    path = 'resources/img/commenting2.png',
    onSelected = function()
      if love.system.getOS() == 'Android' then
        love.system.openURL('https://play.google.com/store/apps/details?id=com.voodoocactus.games.puzzler')
      end
    end,
    color = { Lume.color('#77769e',255) },
  })
  -- facebook
  ImageButton:new(self.world,conf.width/2+5,280,{
    path = 'resources/img/facebook-official.png',
    onSelected = function()
      love.system.openURL('https://www.facebook.com/voodocactustudio/')
    end,
    color = { Lume.color('#77769e',255) },
  })
  -- Quit app
  -- ImageButton:new(self.world,0,0,{
  --   path = 'resources/img/arrow-left.png',
  --   onSelected = function()
  --     love.event.push('quit')
  --   end,
  --   color = { Lume.color('#77769e',255) },
  -- })

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
    table.sort(items,Entity.sortByZOrderAsc)
    Lume.each(items,'draw')
end

function Start:draw()
  Push:start()
    g.setColor(to_rgb(palette.text))
    g.clear(to_rgb(palette.bg))

    self.camera:draw(function(l,t,w,h)
      self:drawEntities(l,t,w,h) -- Call a function so it can be override by other state
    end)

  g.setColor(255,255,255,255)
  g.draw(self.logo,65,20,0,0.8,0.8)
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
