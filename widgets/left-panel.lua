local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

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
  -- Create a promptbox for each screen
  local promptbox = awful.widget.prompt()
  -- Create a taglist widget
  local taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {}, nil, wibox.layout.fixed.vertical())

  s.mypromptbox = promptbox

  local panel = awful.wibar(
    {
      position = "left",
      screen = s,
      bg = beautiful.panel_bg,
      fg = beautiful.fg_normal,
      width = w,
      ontop = true,
    }
  )

  panel:setup {
    layout = wibox.layout.align.vertical,
    taglist,
    promptbox,
    nil,
  }
  return panel
end

return LeftPanel
