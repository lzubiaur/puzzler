local Game = require 'common.game'
local Piece = require 'entities.piece'
local Box = require 'entities.box'

local PiecesDebug = Game:addState('PiecesDebug')

function PiecesDebug:enteredState()
  Log.info('Entered state "pieces debug"')
  self.commited = 0

  local names = {
    -- '_1','_2','I3','L3'
    'I4','O4','L4','S4','T4',
    -- 'F5','I5','L5','N5','P5','T5','U5','V5','W5','X5','Y5','Z5'
  }

  c = Hue.new('#ff0000')
  colors = {}
  for i=1,10 do
    local r,g,b,a = to_rgb(c)
    print(r,g,b,a)
    table.insert(colors,{r,g,b,a})
    c = c:hue_offset(20)
  end

  for i=1,#names do
    Piece:new(self.world,names[i],colors[i],i*50,0)
  end

  self.box = Box:new(self.world,0,100)
end

-- function PiecesDebug:draw()
-- end

-- function PiecesDebug:update(dt)
-- end

function PiecesDebug:mousepressed(x, y, button, istouch)
  local x,y = self.camera:toWorld(Push:toGame(x,y))
  local items, len = self.world:queryPoint(x,y,nil)
  for i=1,len do
    if items[i].piece then
      self.piece = items[i].piece
      self.dx,self.dy = self.piece:getLocalPoint(x,y)
    end
  end
end

function PiecesDebug:mousemoved(x, y, dx, dy, istouch)
  x,y = self.camera:toWorld(Push:toGame(x,y))
  if self.piece then
    self.box:clear({100,100,100,128})
    self.piece:moveAndQuery(x-self.dx,y-self.dy)
  end
end

function PiecesDebug:mousereleased(x, y, button, istouch)
  if self.piece then
    local count = self.piece:commit()
    Log.debug('commited',count)
    Log.debug('commited',self.box.count)
    self.commited = self.commited + count
    if self.commited == self.box.count then
      Log.info('Solved')
    end
    self.piece = nil
  end
end

function PiecesDebug:keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    self:popState()
  elseif key == 'right' then
    Beholder.trigger('Right')
  end
end

return PiecesDebug
