-- game.lua

local Game = Class('Game'):include(Stateful)

function Game:initialize()
  Log.info('Create the game instance.')

  self.state = {
    path = 'db.data', -- this database filename
    cur = 1, -- current level
    levels = {} -- Array with all levels states.
  }

  self:loadGameState()

  -- shader = love.graphics.newShader("resources/shaders/separate_chroma.glsl")
  -- Uncomment below to use two post-process effects
  -- Push:setupCanvas({
  --   -- { name = 'noshader' }, -- in case we want a no shader canvas
  --   { name = 'shader1', shader = kaleidoscope },
  -- })
  -- Push:setShader(shader2) --applied to final render

  -- In case we only want one shader
  -- Push:setShader(shader1)

  -- default graphics params
  love.graphics.setLineWidth(conf.lineWidth)
  -- love.graphics.setLineJoin('bevel')
  love.graphics.setPointSize(conf.pointSize)

  i18n.loadFile('resources/i18n.lua')

  -- self.nextState = 'Start'
  self:gotoState('Start')
end

function Game:destroy()
  self:saveGameState()
end

function Game:saveGameState()
  Log.info('Serialize game state',Inspect(self.state))
  local data = Binser.serialize(self.state)
  if not data then
    Log.error('Cannot serialize game state')
    return
  end
  local success,msg = love.filesystem.write(self.state.path,data)
  if not success then
    Log.error('Cannot write to database:',msg)
  end
end

function Game:loadGameState()
  local fs = love.filesystem
  if fs.exists(self.state.path) then
    local data,len = fs.read(self.state.path)
    if not data then
      Log.error('Cannot read file:',len)
      return
    end
    data,len = Binser.deserialize(data)
    if data then
      self.state = data[1]
      Log.debug('Game state = ',Inspect(self.state))
    else
      Log.error('Cannot read deserialize database')
    end
  end
end

function Game:updateShaders(dt,shift,alpha)
  -- shader:send('alpha', alpha)
end

function Game:update(dt)
  error('Game:update() is not implemented')
end

function Game:draw()
  error('Game:draw() is not implemented')
end

function Game:keypressed(key, scancode, isRepeat)
  -- nothing to do
end

function Game:touchpressed(id, x, y, dx, dy, pressure)
end

function Game:touchmoved(id, x, y, dx, dy, pressure)
end

function Game:touchreleased(id, x, y, dx, dy, pressure)
end

function Game:mousepressed(x, y, button, istouch)
end

function Game:mousereleased(x, y, button, istouch)
end

function Game:mousemoved(x, y, dx, dy, istouch)
end

function Game:mousefocus(focus)
end

-- Convert from design/game coords to world (aka camera) coords
function Game:toWorld(x,y)
  if self.camera then
    x,y = self.camera:toWorld(x and x or 0,y and y or 0)
  end
  return x,y
end

-- Convert from real/screen coords to world coords
function Game:screenToWorld(x,y)
  -- Push:toGame might return nil
  x,y = Push:toGame(x,y or 0)
  if self.camera then
    x,y = self.camera:toWorld(x and x or 0,y and y or 0)
  end
  return x,y
end

-- function love.wheelmoved( x, y )
-- end

-- Lazy create and returns the current level state
function Game:getCurrentLevelState()
  local state,i = self.state,self.state.cur
  if not state.levels[i] then
    state.levels[i] = {
      score = 0,
      entities = {}
    }
  end
  return state.levels[i]
end

return Game
