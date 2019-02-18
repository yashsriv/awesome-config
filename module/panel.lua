local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi


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

local TopPanel = require("widgets.top-panel")
-- local BottomPanel = require("widgets.bottom-panel")
local LeftPanel = require("widgets.left-panel")
-- local LeftPanelOld = require("widgets.left-panel-old")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
_G.screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create the wibox
    s.leftPanel = LeftPanel(s, dpi(40), dpi(440))
    s.topPanel = TopPanel(s, dpi(40))

    -- s.connect_signal("removed", destruct_panel)
end)

local function destruct_panel(s)
  -- Destroy the wibox
  -- local count = 0
  -- for _ in _G.screen do
  --   count = count + 1
  -- end
  -- if count == 1 then
  --   if _G.screen[count] == s then
  --     return
  --   end
  -- end
  s.leftPanel.visible = false
  if s.leftPanel.detach_callback then
    s.leftPanel.detach_callback()
    s.leftPanel.detach_callback = nil
  end
  s.leftPanel = nil
  s.topPanel.visible = false
  if s.topPanel.detach_callback then
    s.topPanel.detach_callback()
    s.topPanel.detach_callback = nil
  end
  s.topPanel = nil
end

-- }}}

-- Hide bars when app go fullscreen
local function updateBarsVisibility()
  for s in _G.screen do
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
  function(_)
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

_G.screen.connect_signal("removed", destruct_panel)
_G.screen.connect_signal("list", function()
                           for s in _G.screen do
                             set_wallpaper(s)
                             s.leftPanel = LeftPanel(s, dpi(40), dpi(440))
                             s.topPanel = TopPanel(s, dpi(40))
                           end
                           updateBarsVisibility()
end)
