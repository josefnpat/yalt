-- Include the yalt library
require("yalt/yalt")
function love.draw()
  -- draw the terminal on the layer that you want. usually, you want this on the last line, so that it's on top.
  yalt:draw()
end
function love.keypressed(key,unicode)
  -- at some point, yalt needs to know when a key is pressed.
  yalt:keypressed(key,unicode)
end
function love.keyreleased(key,unicode)
  -- and also when it is released.
  yalt:keyreleased(key,unicode)
end
--[[
This function, allbeit not required, would make the terminal actually useful.
When the enter button is pressed in YALT, this callback function is called, and the line (as a string) is returned.
Note: Using a php-like explode (as seen in the demo) here helps with argumented functions.
]]-- 
function yalt:callback(line)
  print(line)
  yalt:push(line)
end
