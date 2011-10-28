-- YALT - Yet Another Love Terminal
yalt = {}
require("yalt/config")
yalt.icon_data = love.graphics.newImage(yalt.icon)
yalt.key_disable = { --keys to disable in case they are not in use.
  "up","down","left","right","home","end","pageup","pagedown",--Navigation keys
  "insert","tab","clear","delete",--Editing keys
  "f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","f13","f14","f15",--Function keys
  "numlock","scrollock","ralt","lalt","rmeta","lmeta","lsuper","rsuper","mode","compose",--Modifier keys
  "pause","escape","help","print","sysreq","break","menu","power","euro","undo"--Miscellaneous keys
}
yalt.welcome_line = {
  data = {yalt.welcome},
  output = true
}
yalt.lines = {yalt.welcome_line}
yalt.history = {}
yalt.line = {
  data = {}
}
yalt.holdblink = false
yalt.control = {}
yalt.key_capslock = false
yalt.key_shift = false
yalt.key_ctrl = false
yalt.key_alt = false
yalt.current_height = 0
yalt.lastpress = nil
function yalt:draw_line(rawline)
  rawlines = {}
  current = 0
  for i = 1,string.len(rawline) do
    if string.sub(rawline,i,i) == "\n" then
      table.insert(rawlines,string.sub(rawline,current,i-1))
      current = i+1
    end
    if yalt.font:getWidth(string.sub(rawline,current,i)) > yalt.w then
      table.insert(rawlines,string.sub(rawline,current,i-1))
      current = i
    end
  end
  table.insert(rawlines,string.sub(rawline,current,string.len(rawline)))
  for i,subrawline in ipairs(rawlines) do
    love.graphics.printf(subrawline, yalt.x, yalt.current_height + yalt.y, yalt.w)
    yalt.current_height = yalt.current_height + yalt.font:getHeight(rawline)
  end
end

function yalt:draw()
  if yalt.lastpress and yalt.lastpress.time+yalt.keyrepeat_delay < love.timer.getMicroTime() then
    yalt:keypressed(yalt.lastpress.key,yalt.lastpress.unicode,true)
  end
  if yalt.show then
    if yalt.w == nil then
      yalt.w = love.graphics.getWidth() - yalt.screen_padding*4
    end
    if yalt.h == nil then
      yalt.h = love.graphics.getHeight() - yalt.screen_padding*4
    end
    if yalt.x == nil then
      yalt.x = (love.graphics.getWidth() - yalt.w) / 2
    end
    if yalt.y == nil then
      yalt.y = (love.graphics.getHeight() - yalt.h) / 2
    end
    local orig_r, orig_g, orig_b, orig_a
    orig_r, orig_g, orig_b, orig_a = love.graphics.getColor( )
    local orig_font = love.graphics.getFont( )
    love.graphics.setFont( yalt.font )
    love.graphics.setColor( yalt.screen_color.r, yalt.screen_color.g, yalt.screen_color.b, yalt.screen_color.a )
    love.graphics.rectangle( "fill", yalt.x-yalt.screen_padding, yalt.y-yalt.screen_padding, yalt.w+2*yalt.screen_padding, yalt.h+2*yalt.screen_padding)
    love.graphics.setColor( yalt.text_color.r, yalt.text_color.g, yalt.text_color.b, yalt.text_color.a )
    local current_height = 0
    for i,line in ipairs(yalt.lines) do
      if line.output then
        yalt:draw_line(table.concat(line.data))
      else
        yalt:draw_line(yalt.prefix..table.concat(line.data))    
      end
    end
    local blink = " "
    if love.timer.getMicroTime( ) % yalt.cursorrepeat_delay%2 == 1 or yalt.holdblink then
      blink = yalt.blinkchar
    end
    yalt:draw_line(yalt.prefix..table.concat(yalt.line.data)..blink)
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(yalt.icon_data,yalt.x,yalt.y,0,1,1,yalt.icon_data:getWidth(),yalt.icon_data:getHeight())
    if yalt.current_height > yalt.h then
      table.remove(yalt.lines,1)
    end
    yalt.current_height = 0
    love.graphics.setColor(orig_r,orig_g,orig_b,orig_a)
    love.graphics.setFont( orig_font )
  end
end

function yalt:push(line)
  local new_objs = 
  table.insert(yalt.lines,{data = {line}, output = true})
end

function yalt:in_table(t,s)
  for i,v in pairs(t) do
    if (v==s) then 
      return true
    end
  end
end

yalt.history_current = 0
yalt.history = {}
yalt.history_storage = nil
function yalt:keypressed(key,unicode,keyrepeat)
  if not keyrepeat then
    yalt.lastpress = {time = love.timer.getMicroTime( ), key = key, unicode = unicode}
  end
  if key == "f1" then
    yalt.show = not yalt.show
  else
    yalt.holdblink = true
    if yalt.show then
      if key == "backspace" then -- remove last character
        table.remove(yalt.line.data)
      elseif key == "rshift" or key == "lshift" then -- enable shift
        yalt.key_shift = true
      elseif key == "capslock" then -- enable capslock
        yalt.key_capslock = true
      elseif key == "lctrl" or key == "rctrl" then -- enable ctrl
        -- This does not account for someone who pushes both ctrl keys.
        -- Who does that anyway?
        yalt.key_ctrl = true
      elseif key == "c" and yalt.key_ctrl then -- ctrl-c to cancel
        table.insert(yalt.line.data,"^c")
        table.insert(yalt.lines,yalt.line)
        yalt.line = {data={}}
      elseif key == "l" and yalt.key_ctrl then -- ctrl-c to clear
        yalt.lines = {data={}}
      --[[ DEBUG
      elseif key == "delete" then
        for i,v in ipairs(yalt.history) do
          print(i.."\t"..table.concat(v.data))
        end
        print("max:"..table.maxn(yalt.history))
        print("current:"..yalt.history_current)
      ]]--
      elseif key == "up" then
        if yalt.history_current > 1 then
          yalt.history_current = yalt.history_current - 1     
          if yalt.history_current < 1 then
            yalt.line = {data={}}
          else
            yalt.line = yalt:clone(yalt.history[yalt.history_current])
          end
        end
      elseif key == "down" then
        if yalt.history_current <= table.maxn(yalt.history) then
          yalt.history_current = yalt.history_current + 1
          if yalt.history_current > table.maxn(yalt.history) then
            yalt.line = {data={}}
          else
            yalt.line = yalt:clone(yalt.history[yalt.history_current])
          end
        end
      elseif key == "return"  or key == "kpenter" then -- return key
        table.insert(yalt.lines,yalt.line)
        table.insert(yalt.history,yalt:clone(yalt.line))
        yalt.history_current = table.maxn(yalt.history)+1
        if yalt.callback then
          yalt:callback(table.concat(yalt.line.data))
        end
        yalt.line = {data={}}
      elseif string.sub(key,1,2) == "kp" then --keypad to std keypad values
        table.insert(yalt.line,string.sub(key,3,-1))
      elseif yalt:in_table(yalt.key_disable,key) then -- do nothing, this key is disabled.
      else -- alphabet and multi key presses
        if yalt.key_shift or yalt.key_capslock then
          key = string.char(unicode)
        end
        table.insert(yalt.line.data,key)
      end
    end
  end
end

function yalt:keyreleased(key,unicode)
  yalt.lastpress = nil
  yalt.holdblink = false
  if key == "rshift" or key == "lshift" then -- disable shift
    yalt.key_shift = false
  elseif key == "capslock" then-- disable capslock
    yalt.key_capslock = false
  elseif key == "lctrl" or key == "rctrl" then --disable ctrl
    yalt.key_ctrl = false
  end
end

function yalt:round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function yalt:clone(t)            -- return a copy of the table t
  local new = {}             -- create a new table
  local i, v = next(t, nil)  -- i is an index of t, v = t[i]
  while i do
    if type(v)=="table" then v=yalt:clone(v) end
    new[i] = v
    i, v = next(t, i)        -- get next index
  end
  return new
end
