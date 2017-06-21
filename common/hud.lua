local Game = Class('Game'):include(Stateful)

local HUD = Class('HUD')

function HUD:initialize()
  self.count,self.total = 0,0
end

function HUD:draw()
  g.setColor(to_rgb(palette.text))
  g.printf('Level '..self.currentLevel,0,0,conf.width,'center')
end

function HUD:update(dt)
end

return HUD
