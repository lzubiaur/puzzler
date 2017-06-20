-- level.lua

local Game = require 'common.game'
local Play = require 'gamestates.play'
local Piece = require 'entities.piece'
local Box = require 'entities.box'
local Pane = require 'entities.pane'
local Follow = require 'entities.follow'
-- local Ground = require 'entities.ground'

local Level = Game:addState('Level')

function Level:enteredState()
  Log.info('Entered state "Level"')
  self.entities = {}

  if not self.currentLevel then self.currentLevel = 1 end

  local count = 0
  Beholder.group(self,function()
    Beholder.observe('Docked',function()
      count = count + 1
    end)
    Beholder.observe('Commited',function()
      count = count -1
      if count == 0 then
        self.currentLevel = self.currentLevel + 1
        self:pushState('Win')
      end
    end)
  end)

  local data,len = assert(love.filesystem.read('resources/puzzles.ser'))
  local results,len = assert(Binser.deserialize(data))
  local puzzle = results[self.currentLevel]

  local x,y = self.grid:convertCoords('cell','world',1,5)
  local box = Box:new(self.world,x,y,puzzle.box)
  self.camera:setPosition(box:getCenter())

  -- Transpose the pieces to the origin
  local maxh = 0
  for _,v in pairs(puzzle.solution) do
    local x,y = v[1][1],v[1][2]
    for i=2,#v do
      x = math.min(x,v[i][1])
      y = math.min(y,v[i][2])
    end
    for i=1,#v do
      v[i][1] = v[i][1] - x
      v[i][2] = v[i][2] - y
      maxh = math.max(maxh,v[i][2])
    end
  end
  maxh = maxh + 1

  local color = Hue.new('#ff0000')
  local x = 0
  for k,v in pairs(puzzle.solution) do
    local p = Piece:new(self.world,v,{to_rgb(color)},x,0)
    p:gotoState('Docked')
    color = color:hue_offset(20)
    x = x + #p.matrix[1] * conf.squareSize + 2
  end

  -- Make pane "globally" available through the game instance
  self.pane = Pane:new(self.world,0,0,x,maxh * conf.squareSize)

  -- self.follow = Follow:new(self.world,100,100)
  -- local x,y = box:getCenter()
  -- self.follow:pan(x,y,1)

  -- self:pushState('Debug')

  -- Ground:new(self.world,0,0,conf.width,conf.height,{zOrder = -2})

end

function Level:exitedState()
  -- Just in case Level is popped up but Play is
  -- not exited (and Beholder.reset is not called)
  Beholder.stopObserving(self)
end

function Level:pressed(x, y)
  x,y = self:screenToWorld(x,y)
  local items, len = self.world:queryPoint(x,y,function(item)
    return item.class.name == 'Square' or item.class.name == 'Pane'
  end)
  for i=1,len do
    local ent = items[i].piece and items[i].piece or items[i]
    local dx,dy = ent:getLocalPoint(x,y)
    Beholder.trigger('Selected',ent)
    table.insert(self.entities,{entity=ent,dx=dx,dy=dy})
  end
end

function Level:moved(x, y, dx, dy)
  dx,dy = self:screenToWorld(x-dx,y-dy)
  x,y = self:screenToWorld(x,y)
  for _,v in ipairs(self.entities) do
    Beholder.trigger('Moved',v.entity,x-v.dx,y-v.dy,x-dx,y-dy)
  end
end

function Level:released(x, y)
  x,y = self:screenToWorld(x,y)
  for _,v in ipairs(self.entities) do
    Beholder.trigger('Released',v.entity,x-v.dx,y-v.dy)
  end
  self.entities = {}
end

function Level:touchpressed(id, x, y, dx, dy, pressure)
  self:pressed(x,y)
end

function Level:touchmoved(id, x, y, dx, dy, pressure)
  self:moved(x,y,dx,dy)
end

function Level:touchreleased(id, x, y, dx, dy, pressure)
  self:released(x,y,dx,dy)
end

function Level:mousepressed(x, y, button, istouch)
  if istouch then return end
  self:pressed(x,y)
end

function Level:mousemoved(x, y, dx, dy, istouch)
  if istouch then return end
  self:moved(x,y,dx,dy)
end

function Level:mousereleased(x, y, button, istouch)
  if istouch then return end
  self:released(x,y,dx,dy)
end

function Level:mousefocus(focus)
  if not focus then
    for _,v in ipairs(self.entities) do
      Beholder.trigger('Cancelled',v.entity)
    end
    self.entities = {}
  end
end

function Level:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    self:popState()
  elseif key == 'd' then
    self:pushState('Debug')
  elseif key == 'r' then
    Beholder.trigger('Right')
  elseif key == 'right' then
    self.player.x = self.player.x + 10
  end
end

function Level:exitedState()
  Log.info('Existed state "Level"')
end

function Level:pausedState()
  Log.info('Paused state "Level"')
end

function Level:continuedState()
  Log.info('Continued state "Level"')
end

function Level:pushedState()
  Log.info('Pushed state "Level"')
end

function Level:poppedState()
  Log.info('Popped state "Level"')
end

function Level:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    self:gotoState('Start')
  elseif key == 'r' then
    Beholder.trigger('ResetGame')
    self:gotoState('Play')
  elseif key == 'p' then
    self:pushState('Paused')
  elseif key == 'd' then
    self:pushState('Debug')
  elseif key == 's' then
  end
end

return Level
