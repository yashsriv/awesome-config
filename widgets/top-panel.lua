local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local widget_battery = require("widgets.battery")
local widget_brightness = require("widgets.brightness")
local widget_memory = require("widgets.memory")
local widget_volume = require("widgets.volume")
local mytextclock = wibox.widget.textclock()

local TopPanel = function(s)
    local layoutbox = awful.widget.layoutbox(s)
    layoutbox:buttons(gears.table.join(
                          awful.button({ }, 1, function () awful.layout.inc( 1) end),
                          awful.button({ }, 3, function () awful.layout.inc(-1) end),
                          awful.button({ }, 4, function () awful.layout.inc( 1) end),
                          awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    local panel = awful.wibar(
        {
            position = "top",
            screen = s,
            bg = beautiful.panel_bg,
            fg = beautiful.fg_normal
        }
    )
    -- Add widgets to the wibox
    panel:setup {
        layout = wibox.layout.align.horizontal,
        nil,
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            widget_brightness,
            widget_volume,
            widget_memory,
            widget_battery,
            mytextclock,
            layoutbox,
        },
    }
    return panel
end

return TopPanel
