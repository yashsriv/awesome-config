local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')


-- {{{ Wibar
local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local TopPanel = require("widgets.top-panel")
-- local BottomPanel = require("widgets.bottom-panel")
local LeftPanel = require("widgets.left-panel")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create the wibox
    s.leftPanel = LeftPanel(s, 40)
    s.topPanel = TopPanel(s, 40)
end)
-- }}}

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      -- Order matter here for shadow
      s.topPanel.visible = not fullscreen
      s.leftPanel.visible = not fullscreen
    end
  end
end

_G.tag.connect_signal(
  'property::selected',
  function(s)
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    c.first_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
  end
)
