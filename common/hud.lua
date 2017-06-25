local ImageButton = require 'entities.ui.imagebutton'

local Game = Class('Game'):include(Stateful)

local HUD = Class('HUD')

function HUD:initialize(world,opt)
  opt = opt or {}
  if opt.paneScrollButtons then
    ImageButton:new(world,conf.width-100,conf.height-100,{
      zOrder = 3,
      path = 'resources/img/chevron-right.png',
      onSelected = function()
        Beholder.trigger('PaneScrollRight')
      end
    })
    ImageButton:new(world,0,conf.height-100,{
      zOrder = 3,
      path = 'resources/img/chevron-left.png',
      onSelected = function()
        Beholder.trigger('PaneScrollLeft')
      end
    })
  end
  -- Reset game
  ImageButton:new(world,conf.width-100,0,{
    zOrder = 3,
    path = 'resources/img/undo.png',
    onSelected = function()
      -- Beholder.trigger('ResetLevel')
      Beholder.trigger('GotoNextPuzzle')
    end
  })
  -- Quit gameplay (goto main menu)
  ImageButton:new(world,0,0,{
    path = 'resources/img/arrow-left.png',
    onSelected = function()
      Beholder.trigger('GotoMainMenu')
    end
  })
end

function HUD:draw()
  g.setColor(to_rgb(palette.text))
  g.printf('Level '..self.currentLevel,0,0,conf.width,'center')
end

function HUD:update(dt)
end

return HUD
