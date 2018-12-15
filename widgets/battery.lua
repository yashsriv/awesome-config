local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local vicious = require("vicious")
local wibox = require("wibox")


progress_bat = wibox.widget.progressbar()
text_bat = wibox.widget.textbox()

-- Create wibox with batwidget
batbox = wibox.widget {
  {
    max_value     = 1,
    widget        = progress_bat,
    forced_height = 20,
    forced_width  = 100,
    background_color = gears.color.create_solid_pattern("#222222"),
  },
  {
    widget = text_bat,
  },
  layout = wibox.layout.stack
}
-- batbox = wibox.layout.margin(batbox, 1, 1, 3, 3)
-- Register battery widget
vicious.register(progress_bat, vicious.widgets.bat,
                 function (widget, args)
                   if args[1] == "-" then
                     local val = tonumber(args[2])
                     if val > 75 then
                       progress_bat.color = gears.color.create_solid_pattern("#2e7d32")
                     elseif val > 50 then
                       progress_bat.color = gears.color.create_solid_pattern("#60ad5e")
                     elseif val > 25 then
                       progress_bat.color = gears.color.create_solid_pattern("#f9a825")
                     else
                       progress_bat.color = gears.color.create_solid_pattern("#d32f2f")
                       if val < 15 then
                         naughty.notify({ preset = naughty.config.presets.critical,
                                          title = "Low Battery",
                                          text = "Only " .. args[2] .. "% left",
                                          timeout = 12 })
                       end
                     end
                   else
                     progress_bat.color = gears.color.create_solid_pattern("#283593")
                   end
                   return args[2]
                 end,
                 17, "BAT1")
vicious.register(text_bat, vicious.widgets.bat, "<span foreground=\"white\">$2%</span>", 17, "BAT1")

-- bat_widget = wibox.widget.background()
-- bat_widget:set_widget(batbox)
-- bat_widget:set_bgimage(beautiful.widget_display)

return batbox
