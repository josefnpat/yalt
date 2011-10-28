require("yalt/yalt")
function love.draw()
  yalt:draw()
end
function love.keypressed(key,unicode)
  yalt:keypressed(key,unicode)
end
function love.keyreleased(key,unicode)
  yalt:keyreleased(key,unicode)
end
function yalt:callback(line)
  print(line)
  yalt:push(line)
end
