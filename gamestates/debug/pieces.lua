local Game = require 'common.game'
local Piece = require 'entities.piece'
local Box = require 'entities.box'

local PiecesDebug = Game:addState('PiecesDebug')

function PiecesDebug:enteredState()
  Log.info('Entered state "pieces debug"')
  self.commited = 0

  self.grid = EditGrid.grid(self.camera,{
    size = conf.squareSize*10,
    subdivisions = 10,
    color = {128, 140, 250},
    drawScale = true,
    xColor = {255, 255, 0},
    yColor = {0, 255, 255},
    fadeFactor = 0.3,
    textFadeFactor = 0.5,
    hideOrigin = false,
    -- interval = 200
  })

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
    Piece:new(self.world,names[i],colors[i],i*50,0):gotoState('Docked')
  end

  self.box = Box:new(self.world,0,100)
end

function PiecesDebug:draw()
  Push:start()
  -- g.clear(to_rgb(palette.bg))
  g.clear(0,0,0,255)

  self.grid:draw()
  self.grid:push()
    g.setColor(255,255,255,255)
    g.rectangle('line',0,0,self.worldWidth,self.worldHeight)
    self:drawEntities(self.camera:getVisible()) -- Call a function so it can be override by other state
  g.pop()
  Push:finish()
end

-- function PiecesDebug:update(dt)
-- end

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
    -- self.box:clear({100,100,100,128})
    -- self.piece:moveAndQuery(x-self.dx,y-self.dy)
  end
end

function PiecesDebug:mousereleased(x, y, button, istouch)
  if self.piece then
    -- local count = self.piece:commit()
    -- self.commited = self.commited + count
    -- if self.commited == self.box.count then
    --   Log.info('Solved')
    -- end
    Beholder.trigger('Released',self.piece,x-self.dx,y-self.dy)
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
