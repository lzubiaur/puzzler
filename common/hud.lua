local Button = require 'entities.ui.button'
local ImageButton = require 'entities.ui.imagebutton'

local Game = Class('Game'):include(Stateful)

local HUD = Class('HUD')

function HUD:initialize(world,opt)
  opt = opt or {}
  self.scrollRightButton = ImageButton:new(world,conf.width-50,conf.height-80,{
    zOrder = 3,
    path = 'resources/img/chevron-right.png',
    onSelected = function()
      Beholder.trigger('PaneScrollRight')
    end
  })
  self.scrollLeftButton = ImageButton:new(world,10,conf.height-80,{
    zOrder = 3,
    path = 'resources/img/chevron-left.png',
    onSelected = function()
      Beholder.trigger('PaneScrollLeft')
    end
  })
  -- Reset game
  self.undo = ImageButton:new(world,conf.width-70,0,{
    zOrder = 3,
    path = 'resources/img/undo.png',
    onSelected = function()
      Beholder.trigger('ResetLevel')
    end
  })
  -- Quit gameplay (goto main menu)
  self.back = ImageButton:new(world,0,0,{
    path = 'resources/img/arrow-left.png',
    onSelected = function()
      Beholder.trigger('GotoMainMenu')
    end
  })
  self.next = Button:new(world,conf.width/2-100,250,200,40,{
    onSelected = function()
      Beholder.trigger('GotoNextPuzzle')
    end,
    text='Next',
    color = { Lume.color('#de5a4c',255) },
    textColor = { Lume.color('#fef8d7',255) },
  })
  self.next.hidden = true
  self.more= Button:new(world,conf.width/2-100,250,200,40,{
    onSelected = function()
      if love.system.getOS() == 'Android' then
        love.system.openURL('https://play.google.com/store/apps/dev?id=7240016677312552672')
      end
    end,
    text='More games',
    color = { Lume.color('#de5a4c',255) },
    textColor = { Lume.color('#fef8d7',255) },
  })
  self.more.hidden = true
  Beholder.group(self,function()
    Beholder.observe('Win',function()
      self.next.hidden = false
      self.undo.hidden = true
      self.back.hidden = true
      self.scrollRightButton.hidden = true
      self.scrollLeftButton.hidden = true
    end)
    Beholder.observe('WinSeason',function()
      self.more.hidden = false
      self.undo.hidden = true
      self.back.hidden = true
      self.scrollRightButton.hidden = true
      self.scrollLeftButton.hidden = true
    end)
  end)
end

function HUD:draw()
  g.setColor(to_rgb(palette.text))
  g.printf('Level '..self.currentLevel,0,0,conf.width,'center')
end

function HUD:update(dt)
end

return HUD
