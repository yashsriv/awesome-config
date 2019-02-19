-- Global modules
local awful = require('awful')

-- Local Modules
local icons = require('icons')

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

local function build_tag(icon, screen, selected)
  return {
    icon = icon,
    icon_only = true,
    layout = awful.layout.layouts[1],
    gap_single_client = false,
    gap = 4,
    screen = screen,
    selected = selected or false
  }
end

awful.screen.connect_for_each_screen(
  function(s)
    awful.tag.add(
      1,
      build_tag(icons.firefox, s, true)
    )
    awful.tag.add(
      2,
      build_tag(icons.spacemacs, s, false)
    )
    awful.tag.add(
      3,
      build_tag(icons.terminal, s, false)
    )
    for i = 4, 10, 1 do
      awful.tag.add(
        i,
        build_tag(icons.project(i), s, false)
      )
    end
  end
)

_G.tag.connect_signal(
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
