local Game = require 'common.game'
local Piece = require 'entities.piece'
local Box = require 'entities.box'
local Pane = require 'entities.pane'

local PiecesDebug = Game:addState('POC')

function PiecesDebug:enteredState()
  Log.info('Entered state "pieces debug"')
  self.entities = {}

  local currentLevel = 3
  local count = 0
  Beholder.observe('Docked',function()
    count = count + 1
  end)
  Beholder.observe('Commited',function()
    count = count -1
    if count == 0 then
      self:pushState('Win')
    end
  end)

  local data,len = assert(love.filesystem.read('resources/puzzles.ser'))
  local results,len = assert(Binser.deserialize(data))
  local puzzle = results[currentLevel]

  local x,y = self.grid:convertCoords('cell','world',1,5)
  Box:new(self.world,x,y,puzzle.box)

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

  self.pane = Pane:new(self.world,0,0,x,maxh * conf.squareSize)

end

function PiecesDebug:mousepressed(x, y, button, istouch)
  x,y = self.camera:toWorld(Push:toGame(x,y))
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

function PiecesDebug:mousemoved(x, y, dx, dy, istouch)
  dx,dy = Push:toGame(x-dx,y-dy)
  dx,dy = self.camera:toWorld(dx and dx or 0,dy and dy or 0)
  x,y = self.camera:toWorld(Push:toGame(x,y))
  for _,v in ipairs(self.entities) do
    Beholder.trigger('Moved',v.entity,x-v.dx,y-v.dy,x-dx,y-dy)
  end
end

function PiecesDebug:mousereleased(x, y, button, istouch)
  x,y = self.camera:toWorld(Push:toGame(x,y))
  for _,v in ipairs(self.entities) do
    Beholder.trigger('Released',v.entity,x-v.dx,y-v.dy)
  end
  self.entities = {}
end

function PiecesDebug:mousefocus(focus)
  if not focus then
    for _,v in ipairs(self.entities) do
      Beholder.trigger('Cancelled',v.entity)
    end
    self.entities = {}
  end
end

function PiecesDebug:keypressed(key, scancode, isrepeat)
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
