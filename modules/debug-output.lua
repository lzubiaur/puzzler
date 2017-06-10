-- debug-output

local module = {}

local t = {}
local font = nil
local fontHeight = 0
local enabled = false
local oldFont = nil
local oldColor = {}

function module.init()
  font = g.newFont('resources/fonts/roboto-condensed.fnt','resources/fonts/roboto-condensed.png')
  fontHeight = font:getHeight()
end

function module.draw()
  if not enabled then return end

  local i = 0
  for k,v in pairs(t) do
    g.print(k..':'..v,0,i * fontHeight)
    i = i + 1
  end
end

function module.add(k,v)
  t[k] = v
end

function module.update(k,v)
  t[k] = v
end

function module.setEnabled(status)
  enabled = status
end

function module.toogle()
  enabled = not enabled
end

function module.push()
  oldFont = g.getFont()
  oldColor = {g.getColor()}
  g.setColor(0,255,0,255)
  g.setFont(font)
end

function module.pop()
  g.setFont(oldFont)
  g.setColor(unpack(oldColor))
end

return module
