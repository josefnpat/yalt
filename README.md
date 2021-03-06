YALT - Yet Another Love Terminal

YALT is a library that can be used in conjunction with any software in love.

To integrate YALT into your project, see minimal.lua and the accompanied comments. Then copy the entire yalt subfolder into your project (config.lua  MonospaceTypewriter.ttf  yalt.lua  yalt.png).

<img width=50% src="https://github.com/josefnpat/yalt/raw/master/screenshot.png" />

To configure YALT with custom settings, edit yalt/config.lua.

FEATURES:

* Easy to integrate  
* Highly configurable  
* Restores graphic's color/alpha and fonts to original state when used  
* Looks nice with auto padding depending on resolution  
* Reads in capslock, shift, ctrl and alt properly  
* Scrolls text as it becomes too tall to fit in the window  
* Wraps to the letter, as opposed to the word  
* Capitalizes all letters  
* Shift+numbers return symbols  
* Numpad returns numbers / symbols  
* Key repeating feature works with multiple keys  
* Blinking cursor shows location  
* Up & down keys used for working history  
* System uses tables to differentiate between letters/symbols and commands ("f1","enter","delete", even if they are disabled)  
* Provides simple callback system for processing data entered into yalt  
* Provices simple way to push data back into yalt for response  
* CTRL-C cancels current line, and does not execute it  
* CLRL-L Clears screen  

CREDIT:

* Uses the free [Monospace Typewriter](http://www.dafont.com/monospace-typewrite.font) font
* Uses color theme and icons from the [Tango Desktop Project](http://tango-project.org)
