local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local vicious = require("vicious")
local wibox = require("wibox")
-- local iconPath = '/usr/share/icons/Adwaita/scalable/status/'
-- local iconPath = '/usr/share/icons/Arc/status/symbolic/'
local filesystem = require('gears.filesystem')
local iconPath = filesystem.get_configuration_dir() .. '/icons/battery/'

local text_bat = wibox.widget {
  align = 'center',
  widget = wibox.widget.textbox
}

local battery_icon = wibox.widget {
  image  = iconPath .. 'battery_unknown.svg',
  widget = wibox.widget.imagebox
}

-- Create wibox with batwidget
local batbox = wibox.widget {
  wibox.container.margin(battery_icon, dpi(5), dpi(5), dpi(5), dpi(5)),
  text_bat,
  layout = wibox.layout.fixed.vertical
}
-- batbox = wibox.layout.margin(batbox, 1, 1, 3, 3)
-- Register battery widget
vicious.register(battery_icon, vicious.widgets.bat,
                 function (w, args)
                   local val = tonumber(args[2])
                   if args[1] == "-" then
                     if val == 100 then
                       w.image = iconPath .. "battery_full.svg"
                     elseif val > 90 then
                       w.image = iconPath .. "battery_90.svg"
                     elseif val > 80 then
                       w.image = iconPath .. "battery_80.svg"
                     elseif val > 60 then
                       w.image = iconPath .. "battery_60.svg"
                     elseif val > 50 then
                       w.image = iconPath .. "battery_50.svg"
                     elseif val > 30 then
                       w.image = iconPath .. "battery_30.svg"
                     elseif val > 20 then
                       w.image = iconPath .. "battery_20.svg"
                     else
                       w.image = iconPath .. "battery_alert.svg"
                       if val < 15 then
                         naughty.notify({ preset = naughty.config.presets.critical,
                                          icon = iconPath .. 'battery_alert.svg',
                                          icon_size = 48,
                                          title = "Houston we have a problem",
                                          text = "Only " .. args[2] .. "% left",
                                          timeout = 6 })
                       end
                     end
                   else
                     if val == 100 then
                       w.image = iconPath .. "battery_charging_full.svg"
                     elseif val > 90 then
                       w.image = iconPath .. "battery_charging_90.svg"
                     elseif val > 80 then
                       w.image = iconPath .. "battery_charging_80.svg"
                     elseif val > 60 then
                       w.image = iconPath .. "battery_charging_60.svg"
                     elseif val > 50 then
                       w.image = iconPath .. "battery_charging_50.svg"
                     elseif val > 30 then
                       w.image = iconPath .. "battery_charging_30.svg"
                     else
                       w.image = iconPath .. "battery_charging_20.svg"
                     end
                   end
                   return args[2]
                 end,
                 17, "BAT1")
vicious.register(text_bat, vicious.widgets.bat, "<span foreground=\"white\">$2%</span>", 17, "BAT1")

-- bat_widget = wibox.widget.background()
-- bat_widget:set_widget(batbox)
-- bat_widget:set_bgimage(beautiful.widget_display)

return batbox
