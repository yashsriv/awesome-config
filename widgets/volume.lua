local wibox = require("wibox")
local vicious = require("vicious")
volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume,
                 function(widget, args)
                   if args[2] == "♩" then
                     return args[2] .. " MUTE "
                   end
                   return args[2] .. " " .. args[1] .. "% "
                 end, 2, {"Master", "-D", "pulse"})

return volumewidget
