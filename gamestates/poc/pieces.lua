local Game = require 'common.game'
local Piece = require 'entities.piece'
local Box = require 'entities.box'

local PiecesDebug = Game:addState('POC')

function PiecesDebug:enteredState()
  Log.info('Entered state "pieces debug"')

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
  local puzzle = results[1]
  print(Inspect(results))

  local x,y = self.grid:convertCoords('cell','world',1,5)
  Box:new(self.world,x,y,puzzle.box)

  -- Transpose the pieces to the origin
  for _,v in pairs(puzzle.solution) do
    local x,y = v[1][1],v[1][2]
    for i=1,#v do
      x = math.min(x,v[i][1])
      y = math.min(y,v[i][2])
    end
    for i=1,#v do
      v[i][1] = v[i][1] - x
      v[i][2] = v[i][2] - y
    end
  end

  local color = Hue.new('#ff0000')
  local x = 0
  for k,v in pairs(puzzle.solution) do
    local p = Piece:new(self.world,v,{to_rgb(color)},x,0)
    p:gotoState('Docked')
    color = color:hue_offset(20)
    x = x + #p.matrix[1] * conf.squareSize + 2
  end

end

function PiecesDebug:mousepressed(x, y, button, istouch)
  local x,y = self.camera:toWorld(Push:toGame(x,y))
  local items, len = self.world:queryPoint(x,y,function(item)
    return item.class.name == 'Square' and not item.isBox
  end)
  for i=1,len do
    if items[i].piece then
      self.piece = items[i].piece
      self.dx,self.dy = self.piece:getLocalPoint(x,y)
      Beholder.trigger('Selected',self.piece)
    end
  end
end

function PiecesDebug:mousemoved(x, y, dx, dy, istouch)
  x,y = self.camera:toWorld(Push:toGame(x,y))
  if self.piece then
    Beholder.trigger('Moved',self.piece,x-self.dx,y-self.dy)
  end
end

function PiecesDebug:mousereleased(x, y, button, istouch)
  if self.piece then
    x,y = self.camera:toWorld(Push:toGame(x,y))
    Beholder.trigger('Released',self.piece,x-self.dx,y-self.dy)
    self.piece = nil
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
