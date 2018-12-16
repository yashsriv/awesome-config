local awful = require('awful')
local iconPath = os.getenv('HOME') .. '/.config/awesome/icons/'
local gears = require('gears')

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  awful.layout.suit.floating,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

awful.screen.connect_for_each_screen(
    function(s)
      awful.tag.add(
        1,
        {
          icon = iconPath .. 'firefox-logo.svg',
          icon_only = true,
          layout = awful.layout.layouts[1],
          gap_single_client = false,
          gap = 4,
          screen = s,
          selected = true
        }
      )
      awful.tag.add(
        2,
        {
          layout = awful.layout.layouts[1],
          gap_single_client = false,
          gap = 4,
          screen = s,
        }
      )
      for i = 3, 10, 1 do
        awful.tag.add(
          i,
          {
            layout = awful.layout.layouts[1],
            gap_single_client = false,
            gap = 4,
            screen = s,
          }
        )
      end
    end
)

tag.connect_signal(
    'property::layout',
    function(t)
        local currentLayout = awful.tag.getproperty(t, 'layout')
        if (currentLayout == awful.layout.suit.max) then
            t.gap = 0
        else
            t.gap = 4
        end
    end
)
