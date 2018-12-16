local os = os
local io = io

module("conf.variables")

-- This is used later as the default terminal and editor to run.
terminal = "st"
editor = os.getenv("EDITOR") or "vim"

-- Other variables
rofi = "rofi -combi-modi drun,run -show combi -modi combi"
emacsclient = "emacsclient -nc --socket-name /tmp/emacs1000/server"

-- Theming Variables
theme = "default"
--wallpaper = "/home/yash/.bing-wallpapers/space.jpg"
-- wallpaper = "/home/yash/.bing-wallpapers/wallhaven-684422.png"
function wallpaper(s)
  -- Wallpaper
  local handle = io.popen("/home/yash/.config/awesome/walls.sh")
  local w = handle:read("*a")
  handle:close()
  return w
end

font = "Source Code Pro Semibold 13"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- DO NOT EDIT --
home = os.getenv("HOME")
awconf_dir = home .. "/.config/awesome"
editor_cmd = terminal .. " -e " .. editor
