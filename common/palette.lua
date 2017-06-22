-- color.lua

function createPalette(c)
  local t1,t2 = c:triadic()
  return {
    base = Hue.new('#043642'),
    fg   = Hue.new('#cd4e11'),
    bg   = Hue.new('#efe8d4'),
    main = Hue.new('#D8D2B0'),
    line = c:desaturate_by(.5),
    fill = c:desaturate_by(.2),
    text = Hue.new('#839496'),
  }
end

function offsetHuePalette(o)
  for k,v in pairs(palette) do
    palette[k] = v:hue_offset(o)
  end
end

palette = createPalette(Hue.new('#333333'))
-- offsetHuePalette(60)

-- TODO doesnt work
function to_rgb(c,alpha)
  local r,g,b = Hue.hsl_to_rgb(c.H,c.S,c.L)
  return r*256,g*256,b*256,alpha or 255
  -- Using Lume.color is slower/more expensive
  -- return Lume.color(color:to_rgb(),255)
end

-- TODO run stress testing on both to_rgb functions
-- function to_rgb(color)
--   local r,g,b = Hue.hsl_to_rgb(color.H,color.S,color.L)
--   return r*256,g*256,b*256
-- end
