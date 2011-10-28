-- CONFIGURATION

-- Set to true to enable on startup
yalt.show = false
-- Key to toggle yalt.
yalt.key_toggle = "f1"
-- Set x and or y to put in specific spot. Default centers the yalt.
yalt.x = nil
yalt.y = nil
-- Set to nil for fullscreen with padding.
yalt.w = love.graphics.getWidth()*0.6
yalt.h = love.graphics.getHeight()*0.6
-- Change the screen padding, screen color/aplha and the icon.
yalt.screen_padding = 32
yalt.screen_color = {r = 46, g = 52, b = 54, a = 224} -- Tango! aluminium 6 @ 75% opacity
yalt.icon =  "yalt/yalt.png" -- From Tango! Desktop Project
-- Change the font, font size and font color/aplha
yalt.font = love.graphics.newFont( "yalt/MonospaceTypewriter.ttf", 12 )
yalt.text_color = {r = 138, g = 226, b = 52, a = 255} -- Tango! Chameleon 1
-- Change the line input's prefix. Currently userless unix style.
yalt.prefix = "$ "
-- Change the blinking location character. To disable, set as ""
yalt.blinkchar = "_"
-- Change this so you can have a different welcome message. nil for none.
yalt.welcome = "YALT - Yet Another Love Terminal"
-- Time in seconds that it takes for the key repeat to turn on.
yalt.keyrepeat_delay = 0.7
yalt.cursorrepeat_delay = 2
