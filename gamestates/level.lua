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

  self.hud = HUD:new(self.world)
  self.hud.currentLevel = self.state.cli

  local puzzles,len = self:loadWorld()
  self.nPuzzles = len
  assert(self.state.cli <= len,'No puzzle for level id '..self.state.cli)
  local puzzle = puzzles[self.state.cli]

  self:createCamera(conf.width,conf.height,0,0,0,0,conf.squareSize)

  -- Transpose the pieces to the origin
  local paneWidth,pieceMargin,maxh = 0,1,0
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
      paneWidth = paneWidth + v[i][1] * conf.squareSize + pieceMargin
    end
  end
  maxh = maxh + 1
  local paneY = conf.height - maxh * conf.squareSize

  -- Create the box
  local pw,ph = puzzle.width,puzzle.height
  local w,h = conf.width/conf.squareSize,(conf.height/conf.squareSize)-maxh
  local x,y = self.grid:convertCoords('cell','world',(w-pw)/2,(h-ph)/2)
  local box = Box:new(self.world,x,y,puzzle.box)
  -- self.camera:setPosition(box:getCenter())

  local count = #puzzle.solution
  Beholder.group(self,function()
    Beholder.observe('Commited',function()
      count = count -1
      if count == 0 then
        self:gotoNextPuzzle()
      end
    end)
    Beholder.observe('GotoNextPuzzle',function()
      self:gotoNextPuzzle()
    end)
  end)

  -- offsetHuePalette(20)

  local color = palette.fg
  local x,p,pieces = 0,nil,{}
  for i=1,count do
    p = Piece:new(self.world,i,puzzle.solution[i],x,paneY,{color={to_rgb(color)}})
    color = color:hue_offset(30)
    -- color = color:lighten_by(1.10)
    -- XXX
    x = x + #p.matrix[1] * conf.squareSize + 1
    table.insert(pieces,p)
  end

  Beholder.group(self,function()
    Beholder.observe('Docked',function()
      count = count + 1
    end)
  end)

  local paneWidth = x,true
  if paneWidth < conf.width then
    x = (conf.width - paneWidth) / 2
    self.hud.scrollLeftButton.hidden = true
    self.hud.scrollRightButton.hidden = true
  else
    x = 0
  end

  -- Make pane "globally" available through the game instance
  self.pane = Pane:new(self.world,0,paneY,paneWidth,maxh*conf.squareSize)
  if x > 0 then
    self.pane:teleport(x,paneY)
    for _,p in ipairs(pieces) do
      p:moveSquares(p.x+x,p.y)
    end
  end

  -- self.follow = Follow:new(self.world,100,100)
  -- local x,y = box:getCenter()
  -- self.follow:pan(x,y,1)

  -- self:pushState('Debug')

  -- Ground:new(self.world,0,0,conf.width,conf.height,{zOrder = -2})

  self:createBasicHandlers()
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
  -- XXX write game state now or when the game quits?
  self:writeGameState()
end

function Level:drawAfterCamera()
  self.hud:draw()
end

function Level:gotoNextPuzzle()
  if self.state.cli < self.nPuzzles then
    -- Must save state before incrementing the level id
    self:savePuzzleState()
    self.state.cli = self.state.cli + 1
    self:gotoState('Play')
  else
    self:pushState('WinSeason')
  end
end

function Level:gotoPreviousPuzzle()
  if self.state.cli > 1 then
    -- Must save state before decrementing the level id
    self:savePuzzleState()
    self.state.cli = self.state.cli - 1
    self:gotoState('Play')
  end
end

function Level:onGotoMainMenu()
  self:savePuzzleState()
  self:gotoState('Start')
end

function Level:onResetLevel()
  self:resetCurrentLevelState()
  self:gotoState('Play')
end

function Level:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    Beholder.trigger('GotoMainMenu')
  elseif key == 'r' then
    Beholder.trigger('ResetGame')
  elseif key == 'p' then
    -- self:pushState('Paused')
  end
  if conf.build == 'debug' then
    if key == 'd' then
      self:pushState('Debug')
    elseif key == 'n' then
      self:gotoNextPuzzle()
    elseif key == 'p' then
      self:gotoPreviousPuzzle()
    end
  end
end

return Level
