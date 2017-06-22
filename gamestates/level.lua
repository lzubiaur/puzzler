-- level.lua

local Game = require 'common.game'
local Play = require 'gamestates.play'
local Piece = require 'entities.piece'
local Box = require 'entities.box'
local Pane = require 'entities.pane'
local Follow = require 'entities.follow'
local HUD = require 'common.hud'
-- local Ground = require 'entities.ground'

local Level = Game:addState('Level')

function Level:enteredState()
  Log.info('Entered state "Level"')
  self.entities = {}

  local levelId = self.state.cli

  self.hud = HUD:new()
  self.hud.currentLevel = self.state.cli


  local puzzles,len = self:loadWorld()
  assert(self.state.cli <= len,'Current level id'..self.state.cli..' > number of puzzles '..len)
  local puzzle = puzzles[self.state.cli]

  self:createCamera(conf.width * len, conf.height)

  local x,y = self.grid:convertCoords('cell','world',0,5)
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

  local count = #puzzle.solution
  self.hud.count,self.hud.total = count,count
  Beholder.group(self,function()
    Beholder.observe('Commited',function()
      count = count -1
      self.hud.count = count
      if count == 0 then
        self.state.cli = self.state.cli + 1
        self:pushState('Win')
      end
    end)
  end)

  -- offsetHuePalette(20)

  local paneY = conf.height - (maxh + 2) * conf.squareSize
  local color = palette.fg
  local x,p = 0
  for i=1,count do
    p = Piece:new(self.world,i,puzzle.solution[i],x,paneY,{color={to_rgb(color)}})
    color = color:hue_offset(30)
    -- color = color:lighten_by(1.10)
    -- XXX
    x = x + #p.matrix[1] * conf.squareSize + 1
  end

  Beholder.group(self,function()
    Beholder.observe('Docked',function()
      count = count + 1
      self.hud.count = count
    end)
  end)

  -- Make pane "globally" available through the game instance
  self.pane = Pane:new(self.world,0,paneY,x,maxh*conf.squareSize)

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

function Level:loadWorld()
  local filename = string.format('resources/maps/map%02d.lua',self.state.csi)

  local data,len = assert(love.filesystem.read('resources/puzzles.ser'))
  return assert(Binser.deserialize(data))
end

function Level:savePuzzleState()
  Beholder.trigger('SaveState')
end

function Level:drawAfterCamera()
  self.hud:draw()
end

function Level:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    Beholder.trigger('SaveState')
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
