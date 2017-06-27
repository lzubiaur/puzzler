-- square
local Entity = require 'entities.entity'

local Square = Class('Square',Entity)

function Square:initialize(world,x,y,opt)
  assert(opt and opt.color,'Missing color')
  self.color = opt.color
  Entity.initialize(self,world,x,y,conf.squareSize,conf.squareSize,opt)
  self.color2 = { to_rgb(rgb_to_color(unpack(self.color)):lighten_by(.8)) }
end

function Square:draw()
  g.setColor(unpack(self.color))
  g.rectangle('fill',self.x,self.y,self.w,self.h)
  g.setColor(unpack(self.color2))
  g.setLineWidth(1)
  local o = 0
  for i=1,3 do
    g.rectangle('line',self.x+2+o,self.y+2+o,self.w-4-o*2,self.h-4-o*2)
    o = o + 4
  end
end

return Square
