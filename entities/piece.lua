-- piece.lua
local Entity = require 'entities.entity'
local Square = require 'entities.square'

local Piece = Class('Piece',Entity):include(Stateful)

local pieces = {
  -- monocube
  _1 = { {0,0} },
  -- dicube
  _2 = { {0,0},{0,1} },
  -- tricubes
  I3 = { {0,0},{0,1},{0,2} },
  L3 = { {0,1},{0,0},{1,0} },
  -- tetrominoes
  I4 = { {0,0},{0,1},{0,2},{0,3} },
  O4 = { {0,0},{0,1},{1,1},{1,0} },
  J4 = { {0,2},{0,1},{0,0},{1,0} },
  L4 = { {0,0},{1,0},{1,1},{1,2} },
  Z4 = { {0,2},{0,1},{1,1},{1,0} },
  S4 = { {0,0},{0,1},{1,1},{1,2} },
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
  return m
end

-- Rotate Right
function Piece:rotr()
  self.matrix = Matrix.rotr(self.matrix)
  self:createSquares(self.matrix)
end

function Piece:mirror()
  self.matrix = Matrix.invert(self.matrix)
  self.createSquares(self.matrix)
end

function Piece:createSquares(p)
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

function Piece:initialize(world,name,color,x,y)
  local p = pieces[name]
  assert(p,'Unknow piece: '..name)
  self.name,self.commited,self.targets = name,false,{}
  self.color = color
  self.matrix = to_matrix(p)
  -- TODO piece w,h
  local w,h = conf.squareSize,conf.squareSize
  Entity.initialize(self,world,x,y,w,h)
  self:createSquares(self.matrix)
  -- save original coord
  self.ox,self.oy = x,y
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

function Piece:checkCells()
  local free,taken = 0,0
  for _,s in ipairs(self.squares) do
    local cx,cy = s:getCenter()
    local items,len = self.world:queryPoint(cx,cy,function(item)
      return item.class.name == 'Square' and item ~= s
    end)
    if len == 1 and items[1].isBox then
      free = free + 1
    elseif len > 0 then
      taken = taken + 1
    end
  end
  return free,taken
end

function Piece:moveToCurrentCell()
  x,y = self:getCenter()
  x,y = game.grid:convertCoords('world','cell',x,y)
  x,y = game.grid:convertCoords('cell','world',x,y)
  self:moveSquares(x,y)
end

function Piece:draw()
  -- g.setColor(0,255,255,255)
  -- g.rectangle('line',self.x,self.y,self.w,self.h)
end

function Piece:update()
end

return Piece
