-- imagebutton.lua

local Entity = require 'entities.entity'
local Button = require 'entities.ui.button'

local ImageButton = Class('ImageButton',Button)

function ImageButton:initialize(world,x,y,opt)
  assert(opt and opt.path,'No image provided')
  self.image = g.newImage(opt.path)
  Button.initialize(self,world,x,y,self.image:getWidth(),self.image:getHeight(),opt)
end

function ImageButton:draw()
  g.setColor(unpack(self.color))
  g.draw(self.image,self.x,self.y)
end

return ImageButton
