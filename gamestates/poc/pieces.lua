local Game = require 'common.game'
local Piece = require 'entities.piece'
local Box = require 'entities.box'

local PiecesDebug = Game:addState('POC')

function PiecesDebug:enteredState()
  Log.info('Entered state "pieces debug"')

  local names = {
    -- '_1','_2','I3','L3'
    'I4','O4','L4','S4','T4',
    -- 'F5','I5','L5','N5','P5','T5','U5','V5','W5','X5','Y5','Z5'
  }

  c = Hue.new('#ff0000')
  colors = {}
  for i=1,10 do
    table.insert(colors,{to_rgb(c)})
    c = c:hue_offset(20)
  end

  for i=1,#names do
    Piece:new(self.world,names[i],colors[i],i*50,0):gotoState('Docked')
  end

  self.box = Box:new(self.world,self.grid:convertCoords('cell','world',1,5))

  local count = 0
  Beholder.observe('Docked',function()
    count = count + 1
  end)
  Beholder.observe('Commited',function()
    count = count -1
    if count == 0 then
      Log.info('Solved!')
    end
  end)
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
