-- piece.lua
local Entity = require 'entities.entity'
local Square = require 'entities.square'

local Piece = Class('Piece',Entity):include(Stateful)

local pieces = {
  -- monocube
  O1 = { {0,0} },
  -- dicube
  I2 = { {0,0},{0,1} },
  -- tricubes
  I3 = { {0,0},{0,1},{0,2} },
  V3 = { {0,1},{0,0},{1,0} }, -- also called 'L3'
  -- tetrominoes
  I4 = { {0,0},{0,1},{0,2},{0,3} },
  O4 = { {0,0},{0,1},{1,1},{1,0} },
  J4 = { {0,2},{0,1},{0,0},{1,0} },
  L4 = { {0,0},{1,0},{1,1},{1,2} }, -- mirrored J4
  Z4 = { {0,2},{0,1},{1,1},{1,0} },
  S4 = { {0,0},{0,1},{1,1},{1,2} }, -- mirrored Z4
  T4 = { {0,1},{1,1},{2,1},{1,0} },
  -- pentominoes
  F5 = { {2,2},{1,2},{1,1},{1,0},{0,1} },
  I5 = { {0,4},{0,3},{0,2},{0,1},{0,0} },
  L5 = { {0,3},{0,2},{0,1},{0,0},{1,0} },
  N5 = { {0,0},{0,1},{1,1},{1,2},{1,3} },
  P5 = { {0,0},{0,1},{0,2},{1,2},{1,1} },
  T5 = { {0,2},{1,2},{2,2},{1,0},{1,1} },
  U5 = { {0,1},{0,0},{1,0},{2,0},{2,1} },
  V5 = { {0,2},{0,1},{0,0},{1,0},{2,0} },
  W5 = { {0,2},{0,1},{1,1},{1,0},{2,0} },
  X5 = { {0,1},{1,1},{2,1},{1,2},{1,0} },
  Y5 = { {0,3},{0,2},{0,1},{0,0},{1,1} },
  Z5 = { {0,2},{1,2},{1,1},{1,0},{2,0} },
}

local function to_matrix(t)
  local m = {}
  local w,h = 1,1
  local order = #t
  for i=1,order do
    w = math.max(w,t[i][1]+1)
    h = math.max(h,t[i][2]+1)
  end
  for i=1,h do
    m[i] = {}
    for j=1,w do
      m[i][j] = 0
    end
  end
  for i=1,order do
    local x = t[i][1]+1
    local y = t[i][2]+1
    m[y][x] = 1
  end
  return m,w,h
end

function Piece.getPieces()
  return pieces
end

-- Rotate Right
function Piece:rotr()
  self.matrix = Matrix.rotr(self.matrix)
  self:createSquares()
  -- local row,col = self.matrix:size()
  -- self:resize(col*conf.squareSize,row*conf.squareSize)
end

function Piece:mirror()
  self.matrix = Matrix.invert(self.matrix)
  self.createSquares()
  -- self:resize(self.matrix:size())
end

function Piece:createSquares()
  -- delete old squares
  if self.squares then
    for i=1,#self.squares do
      self.squares[i]:destroy()
      self.squares[i] = nil
    end
  end
  self.squares = {}
  local m = self.matrix
  for i=1,#m do
    for j=1,#m[i] do
      if m[i][j] == 1 then
        local sx,sy = self.x+(j-1)*conf.squareSize,self.y+(i-1)*conf.squareSize
        local square = Square:new(self.world,sx,sy)
        square.piece = self
        square.color = self.color
        table.insert(self.squares,square)
      end
    end
  end
end

function Piece:initialize(world,t,color,x,y)
  self.color,self.ox,self.oy = color,x,y
  if type(t) == 'string' then
    t = pieces[t]
    assert(t,'Unknow piece')
    self.name = t
  end
  local w,h
  self.matrix,w,h = to_matrix(t)
  Entity.initialize(self,world,x,y,conf.squareSize,conf.squareSize)
  self:createSquares()
end

function Piece:move(x,y)
end

function Piece:drop(x,y)
end

function Piece:filter(other)
  return other.isBox and 'cross' or nil
end

function Piece:getOrder()
  return #self.squares
end

function Piece:moveSquares(x,y)
  local dx,dy = self.x-x, self.y-y
  self.x,self.y = self.world:move(self,x,y,self.filter)
  for i=1,#self.squares do
    local s = self.squares[i]
    s.x,s.y = self.world:move(s,s.x-dx,s.y-dy,self.filter)
  end
end

-- Returns the numbers of free and not free squares below this pieces but
-- inside the box.
function Piece:checkCells()
  local free,taken = 0,0
  for _,s in ipairs(self.squares) do
    local cx,cy = s:getCenter()
    local items,len = self.world:queryPoint(cx,cy,function(item)
      -- Filters out this square but includes also the box itself
      return (item.class.name == 'Square' and item ~= s) or item.class.name == 'Box'
    end)
    -- Only take into account squares that are wihtin the box
    if len == 2 and (items[1].isBox or items[2].isBox) then
      free = free + 1
    elseif len > 1 then
      taken = taken + 1
    end
  end
  return free,taken
end

function Piece:moveToCurrentCell()
  -- Using EditGrid
  local x,y = self:getCenter()
  x,y = game.grid:convertCoords('world','cell',x,y)
  x,y = game.grid:convertCoords('cell','world',x,y)
  -- Using bump's grid
  -- local x,y = self.world:toWorld(self.world:toCell(self:getCenter()))
  -- Using Tiled grid
  -- local x,y = self.map:convertPixelToTile(self:getCenter())
  -- x,y = self.map:converTileToPixel(x,y)
  self:moveSquares(x,y)
end

function Piece:draw()
  g.setColor(0,255,255,255)
  g.rectangle('line',self.x,self.y,self.w,self.h)
end

function Piece:update()
end

return Piece
