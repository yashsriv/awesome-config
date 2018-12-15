local string = { format = string.format }

local helpers = require("vicious.helpers")
local wibox = require("wibox")
local vicious = require("vicious")

local widget = wibox.widget.textbox()
vicious.register(widget,
                 function (format, warg)
                   if not warg then return end
                   local backlight = helpers.pathtotable("/sys/class/backlight/"..warg)
                   local current_val = tonumber(backlight.brightness)
                   local max_val = tonumber(backlight.max_brightness)
                   local perc = current_val * 100 / max_val
                   return {string.format("%.0f", perc)}
                 end,
                 "☀ $1 ", 2, "intel_backlight")

return widget
