require("yalt/yalt")
image = love.graphics.newImage( "image.png" )
love.graphics.setBackgroundColor(114,159,207) -- Tango! Sky Blue 1
--YALT restores the graphics color and font to what it was originally.
love.graphics.setColor(46,52,54,255)-- Tango! Aluminium 6

speed = 1
function love.draw()
  love.graphics.print( "\"YALT - Yet Another Love Terminal\" demo project.\nPress F1 to open YALT.", 100, 100)
  love.graphics.draw( image, 400, 300, math.sin(r_term/speed)/2, 1,1,150,150)
  yalt:draw()--Required
end

function love.keypressed(key,unicode)
  yalt:keypressed(key,unicode)--Required
end

function love.keyreleased(key,unicode)
  yalt:keyreleased(key,unicode)--Required
end

function yalt:callback(input)
  ia = explode(" ",input)
  if ia[1] == "hello" then
    if ia[2] == "world" then
      if ia[3] then
        name = ia[3].."."
      else
        name = "friend."
      end
      yalt:push("Why, hello there!\nHow nice of you to stop by, "..name)
    else
      i_dunno(input)
    end
  else
    i_dunno(input)
  end
end

function i_dunno(input)
  yalt:push("unknown command \""..input.."\".")
end
r_term = 0
function love.update(dt)
  r_term = dt + r_term
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
