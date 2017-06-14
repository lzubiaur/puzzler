-- box.lua

local Entity = require 'entities.entity'
local Square = require 'entities.square'

local Box = Class('Box',Entity)

function Box:initialize(world,x,y,t)
  self.squares,w,h = {},0,#t
  for i=1,h do
    local _w = #t[i]
    for j=1,_w do
      if t[i][j] ~= '_' then
        local square = Square:new(world,x+(j-1)*conf.squareSize,y+(i-1)*conf.squareSize,{zOrder=-1})
        square.isBox = true
        square.color = {100,100,100,128}
        table.insert(self.squares,square)
      end
    end
    w = math.max(w,_w)
  end
  Entity.initialize(self,world,x,y,w*conf.squareSize,h*conf.squareSize)
end

function Box:clear(c)
  for i=1,#self.squares do
    self.squares[i].color = c
  end
end

function Box:draw()
  g.setColor(0,255,0,255)
  g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Box
