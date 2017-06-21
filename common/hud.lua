local Game = Class('Game'):include(Stateful)

local HUD = Class('HUD')

function HUD:initialize()
  self.count,self.total = 0,0
end

function HUD:draw()
  g.print(Lume.format('Level: {currentLevel} Pieces:{count}/{total}',self))
end

function HUD:update(dt)
end

return HUD
