-- main.lua

local platform = love.system.getOS()

-- Global game configuration
conf = {
  version = require 'common.version',
  build = require 'common.build', -- release/debug build
  -- The game fixed resolution. Use a 16:9 aspect ratio
  width = 360, height = 640,
  -- Bump world cell size. Should be a multiple of the map's tile size.
  cellSize = 64,
  -- Run on a mobile platform?
  mobile = platform == 'Android' or platform == 'iOS',
  -- grafics
  lineWidth = 2,
  pointSize = 5,
  -- TODO add camera parameters (camera borders, smooth/lerp)
  camOffsetX = 150, -- offset from the player
  camMarginX = 150, -- horizontal outer space allowed to the camera to move outside the map/world
  camMarginY = 150, -- veritcal margin must be big enough so the player is still updated when outside the map.
  -- Player config
  gravity = 0, -- vertical gravity (default 1000)
  playerVelocity = 0, -- Player horizontal velocity in pixel/second. Default 500.
  playerImpulse = -1000, -- vertical impulse when jumping
  playerImpulse2 = -1000, -- jump 2 impulse
  playerMaxVelocity = { x=1000,y=1000 },
  -- custom
  squareSize = 32,
}

-- Load 3rd party libraries/modules globally.
-- All modules should start with a capital letter.
Class     = require 'modules.middleclass'
Stateful  = require 'modules.stateful'
Inspect   = require 'modules.inspect'
Push      = require 'modules.push'
Loader    = require 'modules.love-loader'
Log       = require 'modules.log'
Bump      = require 'modules.bump'
STI       = require 'modules.sti'
Tween     = require 'modules.tween'
Lume      = require 'modules.lume'
Gamera    = require 'modules.gamera'
Beholder  = require 'modules.beholder'
-- Cron      = require 'modules.cron' -- Not used
-- Chain = require 'modules.knife.chain'
i18n      = require 'modules.i18n'
Timer     = require 'modules.hump.timer'
Hue       = require 'modules.colors'
Parallax  = require 'modules.parallax'
Binser    = require 'modules.binser'
Matrix    = require 'modules.matrix'
EditGrid  = require 'modules.editgrid'

-- Love2D shortcuts
g = love.graphics

-- Log level
Log.level = conf.build == 'debug' and 'debug' or 'warn'
Log.usecolor = true

-- Note on loading package:
-- On some platforms like mac osx, the file system is by default not case sensitive
-- which means require is not case sensitive too and might cause some side effect.
-- For instance if we create the file mypackage.lua then require 'myapackage' or
-- require 'MyPackage' or require 'MYPACKAGE' will be able to load  "mypackage.lua".
-- But because it's loaded with different names (mypackage, MyPackage or MYPACKAGE)
-- it will be loaded several times and different instance of the package will be
-- kept in the table package.loaded. This can have side effect if we want to use
-- the same package instance but loaded it with a different name.

require 'common.palette'

local Game = require 'common.game'
-- Game states must be loaded after the Game class is created
require 'gamestates.loading'
require 'gamestates.start'
require 'gamestates.play'
require 'gamestates.paused'
require 'gamestates.level'
require 'gamestates.transitions'
require 'gamestates.win'
if conf.build == 'debug' then
  require 'gamestates.debug'
  require 'gamestates.poc.pieces'
end
require 'entities.docked'
require 'entities.commited'

-- The global game instance
game = nil

function love.load()
  -- Avoid anti-alising/blur when scaling. Useful for pixel art.
  -- love.graphics.setDefaultFilter('nearest', 'nearest', 0)

  -- setBackgroundColor doesnt work with push
  -- love.graphics.setBackgroundColor(0,0,0)

  Log.info(package.path)
  -- TODO get info about lua/luajit version
  Log.info(_VERSION)
  Log.debug('bit',bit ~= nil)

  -- Gets the width and height of the window
  local w,h = love.graphics.getDimensions()

  Push:setupScreen(conf.width, conf.height, w,h, {
    fullscreen = conf.mobile,
    resizable = not conf.mobile,
    highdpi = true,
    canvas = true,  -- Canvas is required to scale the camera properly
    stretched = true, -- Keep aspect ratio or strech to borders
    pixelperfect = false,
  })

  game = Game:new()
end

function love.draw()
  game:draw()
end

function love.update(dt)
  --  if dt > .02 then dt = .02 end
  game:update(dt)
end

-- Must call puse:resize when window resizes.
-- Also call on mobile at app launch because fullscreen is enable.
function love.resize(w, h)
  Push:resize(w, h)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  game:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  game:touchmoved(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  game:touchreleased(id, x, y, dx, dy, pressure)
end

function love.keypressed(key, scancode, isrepeat)
  game:keypressed(key, scancode, isRepeat)
end

-- mouse

function love.mousepressed(x, y, button, istouch)
  game:mousepressed(x,y,button,istouch)
end

function love.mousereleased(x, y, button, istouch)
  game:mousereleased(x,y,button,istouch)
end

function love.mousemoved(x, y, dx, dy, istouch)
  game:mousemoved(x,y,dx,dy,istouch)
end

function love.mousefocus(focus)
  game:mousefocus(focus)
end

-- function love.wheelmoved( x, y )
-- end

-- TODO save/restore session
-- TODO android app is put on background/foreground
function love.focus()
end

function love.visible(visible)
end

function love.quit()
  game:destroy()
  Log.info('Quit app')
end

function love.lowmemory()
  -- TODO run garbage collector
  Log.warn('System is out of memory')
end
