local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')

local TaskList = require("widgets.task-list")
local mytextclock = wibox.widget.textclock()

local TopPanel = function(s, h)
    -- Create a tasklist widget
    local tasklist = TaskList(s)

    -- Create a promptbox for each screen
    local promptbox = awful.widget.prompt()
    s.mypromptbox = promptbox

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
            wibox.widget.systray(),
            mytextclock,
        },
    }
    return panel
end

return TopPanel
