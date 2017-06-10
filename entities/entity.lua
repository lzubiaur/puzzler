-- entity.lua

-- Physic world entity
local Entity = Class('Entity')

function Entity:initialize(world, x,y, w,h, opt)
  opt = opt or {}
  Lume.extend(self,{
    world = world,
    x = x, y = y, -- position
    w = w, h = h, -- size
    -- Options
    zOrder = opt.zOrder or 0, -- draw z order
    mx = opt.mx or 800, my = opt.my or 800, -- maximum velocity
    vx = opt.vx or 0, vy = opt.vy or 0, -- current velocity
    mass = opt.mass or 1,
    id = opt.id
  })
  -- Log.debug('create entity ',self,x,y,self.mx,self.my,self.zOrder)
  -- add this instance to the physics world
  world:add(self, x,y, w,h)
end

function Entity:getPosition()
  return self.x,self.y
end

function Entity:getLocalPoint(x,y)
  return x-self.x,y-self.y
end

function Entity:getCenter()
  return self.x + self.w / 2, self.y + self.h / 2
end

-- TODO to be tested. Need to add push:toScreen but it does not work
function Entity:getCenterToScreen()
  if game.camera then
    return game.camera:toScreen(self:getCenter())
  end
  return self:getCenter()
end

function Entity:applyGravity(dt)
  self.vy = self.vy + self.mass * conf.gravity * dt
  return self.vy
end

function Entity:applyVelocity(dt)
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
end

function Entity:clampVelocity()
  -- self.vx = Lume.sign(self.vx) * Lume.clamp(math.abs(self.vx), 0, self.mx)
  -- self.vy = Lume.sign(self.vy) * Lume.clamp(math.abs(self.vy), 0, self.my)
  self.vx = Lume.clamp(self.vx, -self.mx, self.mx)
  self.vy = Lume.clamp(self.vy, -self.my, self.my)
end

function Entity:destroy()
  -- Log.debug('Destroyed',self.class.name)
  self.world:remove(self)
end

-- code from bump.lua demo
function Entity:applyCollisionNormal(nx, ny, bounciness)
  bounciness = bounciness or 0
  local vx, vy = self.vx, self.vy

  if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
    vx = -vx * bounciness
  end

  if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
    vy = -vy * bounciness
  end

  self.vx, self.vy = vx, vy
end

function Entity:sortByZOrder(other)
  return self.zOrder < other.zOrder
end

function Entity:update(dt)
  -- nothing
end

-- debug draw
function Entity:draw()
  g.rectangle('fill',self.x,self.y,self.w,self.h)
end

function Entity:loadState()
  if not self.id then
    error('No ID for entity',self.class.name)
  end
  return game:getCurrentLevelState().entities[self.id]
end

function Entity:saveState(state)
  if not self.id then
    error('No ID for entity', self.class.name)
  end
  game:getCurrentLevelState().entities[self.id] = state
end

-- Load and restore this entity state from the Game.State database.
-- The entity must have an ID or an error is raised.
function Entity:restoreState()
  local state = self:loadState()
  if state then
    self:gotoState(state.name)
  end
  return state
end

function Entity:observeOnce(...)
  local param, id = {...}
  local callback = table.remove(param,#param)
  table.insert(param, function(...)
    callback(...)
    Beholder.stopObserving(id)
  end)
  id = Beholder.observe(unpack(param))
  return id
end

return Entity
