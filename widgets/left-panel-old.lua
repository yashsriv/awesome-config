local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local variables = require("conf.variables")
local widget_battery = require("widgets.battery")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local LeftPanel = function(s, w)
  local layoutbox = awful.widget.layoutbox(s)
  layoutbox:buttons(gears.table.join(
                      awful.button({ }, 1, function () awful.layout.inc( 1) end),
                      awful.button({ }, 3, function () awful.layout.inc(-1) end),
                      awful.button({ }, 4, function () awful.layout.inc( 1) end),
                      awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  -- Create a taglist widget
  local taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {}, nil, wibox.layout.fixed.vertical())

  local panel = awful.wibar {
    screen = s,
    width = w,
    ontop = true,
    position = "left",
    bg = beautiful.panel_bg,
    fg = beautiful.fg_normal
  }

  panel:setup {
    layout = wibox.layout.align.vertical,
    taglist,
    {
      layout = wibox.layout.fixed.vertical,
    },
    nil,
    {
      widget_battery,
      wibox.container.margin(layoutbox, 4, 4, 4, 4),
      layout = wibox.layout.fixed.vertical,
    }
  }

  return panel
end

return LeftPanel
