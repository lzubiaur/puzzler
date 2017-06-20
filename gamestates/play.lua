-- play.lua

local Game   = require 'common.game'
local Player = require 'entities.player'
local Entity = require 'entities.entity'

local Play = Game:addState('Play')

function Play:enteredState()
  Log.info('Entered state Play')

  -- Must clear the timer on entering the scene or old timer from previous
  -- state might still be running
  Timer.clear()

  -- Create the physics world
  self.world = Bump.newWorld(conf.cellSize)

  -- Load the game map and resources
  local map = self:loadWorldMap(self.world,string.format('resources/maps/map%02d.lua',self.state.cur))

  -- Get player's position from the map
  local x = map.properties.px and map.properties.px or 0
  local y = map.properties.py and map.properties.py or 0
  x,y = map:convertTileToPixel(x,y)

  -- Create the player entity
  self.player = Player:new(self.world, x,y)

  -- Get world map size
  self.worldWidth = map.tilewidth * map.width
  self.worldHeight = map.tileheight * map.height
  Log.debug('Map size in px:',self.worldWidth, self.worldHeight)

  -- Create the follow camera. Size of the camera is the size of the map + offset.
  self.camera = Gamera.new(
    -conf.camMarginX, -conf.camMarginY,
    self.worldWidth + conf.camMarginX, self.worldHeight + conf.camMarginY)
  -- Camera window must be set to the game resolution and not the
  -- the actual screen resolution
  self.camera:setWindow(0,0,conf.width,conf.height)

  if self.follow then
    local px, py = self.follow:getCenter()
    self.camera:setPosition(x + conf.camOffsetX, y)
  end

  -- Create the grid
  self.grid = EditGrid.grid(self.camera,{
    size = conf.squareSize,
    subdivisions = 10,
    color = {128, 140, 250},
    drawScale = false,
    xColor = {255, 255, 0},
    yColor = {0, 255, 255},
    fadeFactor = 0.3,
    textFadeFactor = 0.5,
    hideOrigin = false,
    -- interval = 200
  })

  self.parallax = Parallax(conf.width,conf.height, {offsetX = 0, offsetY = 0})
  self.parallax:addLayer('layer1',1,{ relativeScale = 0.4 })
  self.parallax:addLayer('layer2',1,{ relativeScale = 0.8 })
  -- self.parallax:setTranslation(px,py)

  Beholder.group(self,function()
    Beholder.observe('GameOver',function() self:onGameOver() end)
    Beholder.observe('ResetGame',function() self:onResetGame() end)
    Beholder.observe('Win',function()
      Timer.after(0.5,function()
        self:pushState('Win')
      end)
    end)
    -- Observe all events (for debug purpose)
    if conf.build == 'debug' then
      -- Beholder.observe(function(...) Log.debug('Event triggered > ',...) end)
    end
  end)

  self:pushState('Level')
end

function Play:exitedState()
  Log.info('Exited state Play')
  -- self.music:stop()
  Beholder.stopObserving(self)
  Timer.clear()
end

function Play:pausedState()
  Log.info('Paused state "Play"')
end

function Play:continuedState()
  Log.info('Continued state "Play"')
end

function Play:pushedState()
  Log.info('Pushed state "Play"')
end

function Play:poppedState()
  Log.info('Popped state "Play"')
end

function Play:loadWorldMap(world, filename)
  Log.info('Loading world ', filename)

  -- Load a map exported to Lua from Tiled.
  -- STI provides a bump plugin but since we don't use tiles we'll use a
  -- custom loader
  local map = STI(filename)

  -- Add your custom loading tasks or use the Bump plugin

  return map
end

function Play:drawParallax()
  self.parallax:push('layer1')
    -- Draw parallax layer1
  self.parallax:pop()
  self.parallax:push('layer2')
    -- Draw parallax layer2
  self.parallax:pop()
end

function Play:drawEntities(l,t,w,h)
    -- Only draw only visible entities
    local items,len = self.world:queryRect(l,t,w,h)
    table.sort(items,Entity.sortByZOrder)
    Lume.each(items,'draw')
end

function Play:drawBeforeCamera()
end

function Play:drawAfterCamera()
  g.setColor(255,255,255,255)
  g.print({
    {to_rgb(palette.text)}, 'Esc: quit\n',
    {to_rgb(palette.text)}, 'd: switch debug mode\n',
    {to_rgb(palette.text)}, 'p: pause\n',
  }, conf.width*.5,conf.height*.5)
end

function Play:draw()
  Push:start()
  -- g.clear(to_rgb(palette.bg))
  g.clear(0,0,0,255)

  -- self:drawParallax()

  self:drawBeforeCamera()

  self.camera:draw(function(l,t,w,h)
    g.rectangle('line',0,0,self.worldWidth,self.worldHeight)
    self:drawEntities(l,t,w,h) -- Call a function so it can be override by other state
  end)

  self:drawAfterCamera()

  Push:finish()
end

function Play:onGameOver()
  Log.info('Game Over!')
  self:pushState('GameplayOut')
end

function Play:onResetGame()
  Log.info('Catch event: onResetGame')
end

-- Update visible entities
function Play:updateEntities(dt)
  -- TODO add a padding parameter to update outside the visible windows
  local l,t,h,w = self.camera:getVisible()
  local items,len = self.world:queryRect(l,t,w,h)
  Lume.each(items,'update',dt)
end

function Play:updateCamera(dt)
  -- Move the camera
  -- TODO smooth the camera. X doesnt work smoothly
  -- TODO Check Lume.smooth instead of lerp for X (and y?)
  if self.follow then
    local x,y = self.camera:getPosition()
    local px, py = self.follow:getCenter()
    self.camera:setPosition(px + conf.camOffsetX, Lume.lerp(y,py,0.05))
    self.parallax:setTranslation(px,py)
  end
  -- self.parallax:update(dt) -- not required
end

function Play:update(dt)
  Timer.update(dt)
  -- self:updateShaders(dt)
  self:updateEntities(dt)
  self:updateCamera(dt)
end

function Play:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    self:gotoState('Start')
  elseif key == 'p' then
    self:pushState('Paused')
  elseif key == 'd' then
    self:pushState('Debbug')
  elseif key == 's' then
    -- enable/disable volume...
  end
end

return Play
