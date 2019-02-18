local awful = require('awful')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears')
local wibox = require('wibox')

local TaskList = require("widgets.task-list")
local mytextclock = wibox.widget.textclock()

local clickable_container = require('widgets.clickable-container')

local TopPanel = function(s, h)
    -- Create a tasklist widget
    local tasklist = TaskList(s)

    -- Create a promptbox for each screen
    local promptbox = awful.widget.prompt()
    s.mypromptbox = promptbox

    local layoutbox = clickable_container(
        wibox.container.margin(awful.widget.layoutbox(s), dpi(7), dpi(7), dpi(7), dpi(7)))
    layoutbox:buttons(gears.table.join(
                          awful.button({ }, 1, function () awful.layout.inc( 1) end),
                          awful.button({ }, 3, function () awful.layout.inc(-1) end),
                          awful.button({ }, 4, function () awful.layout.inc( 1) end),
                          awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    local panel = wibox {
        ontop = true,
        screen = s,
        height = h,
        width = s.geometry.width - h,
        x = s.geometry.x + h,
        y = s.geometry.y,
        bg = beautiful.panel_bg,
        fg = beautiful.fg_normal
    }

    panel:struts({ top = h })

    -- Add widgets to the wibox
    panel:setup {
        layout = wibox.layout.align.horizontal,
        tasklist,
        promptbox,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
            layoutbox
        },
    }
    return panel
end

return TopPanel
