local Game = require 'common.game'
local Entity = require 'entities.entity'
local ImageButton = require 'entities.ui.imagebutton'

local Credits = Game:addState('Credits')

function Credits:enteredState()
  Log.debug('Entered state Credits')
  self.swallowTouch = true
  self.swallowLayer = Entity:new(self.world,0,0,conf.width,conf.height,{zOrder=11})
  self.swallowLayer.draw = function()
    g.setColor(30,30,30,200)
    g.rectangle('fill',30,0,conf.width-60,conf.height)
  end
  self.back = ImageButton:new(self.world,0,0,{
    zOrder = 12,
    path = 'resources/img/arrow-left.png',
    onSelected = function()
      self:popState()
    end
  })
end

function Credits:exitedState()
  self.swallowLayer:destroy()
  self.back:destroy()
end

function Credits:drawAfterCamera()
  g.setColor(200,200,200,255)
  g.printf('Puzzler '..require'common.version',0,10,conf.width,'center')
  g.printf([[Love2D game engine
UI icons from Font Awesome
Background patterns from Subtle Patterns
Puzzles design from Polyform Puzzler
Lua modules:
bump,binser,beholder,editgrid,gamera,
lume,middleclass,push,stateful,tween,hump
]],0,20+self.fontHeight,conf.width,'center')
end

function Credits:keypressed(key, scancode, isrepeat)
  if key == 'space' or key == 'escape' then
    self:popState()
  end
end

return Credits
