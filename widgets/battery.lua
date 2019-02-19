-- Global modules
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local wibox = require("wibox")
local vicious = require("vicious")

-- Local modules
local icons = require('icons')

-- Text to display
local text_bat = wibox.widget {
  align = 'center',
  widget = wibox.widget.textbox
}

-- Icon to display
local battery_icon = wibox.widget {
  image  = icons.unknown_battery,
  widget = wibox.widget.imagebox
}

-- Create wibox with batwidget
local batbox = wibox.widget {
  wibox.container.margin(battery_icon, dpi(5), dpi(5), dpi(5), dpi(5)),
  text_bat,
  layout = wibox.layout.fixed.vertical
}
-- Register battery widget
vicious.register(battery_icon, vicious.widgets.bat,
                 function (w, args)
                   local val = tonumber(args[2])
                   if args[1] == "-" then
                     w.image = icons.battery(val, false)
                     if val < 15 then
                       naughty.notify({ preset = naughty.config.presets.critical,
                                        icon = w.image,
                                        icon_size = dpi(40),
                                        title = "Houston we have a problem",
                                        text = "Only " .. args[2] .. "% left",
                                        timeout = 6 })
                     end
                   else
                     w.image = icons.battery(val, true)
                   end
                   return args[2]
                 end,
                 17, "BAT1")

vicious.register(text_bat, vicious.widgets.bat, "<span foreground=\"white\">$2%</span>", 17, "BAT1")

return batbox
