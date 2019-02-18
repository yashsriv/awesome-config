local awful = require('awful')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local wibox = require('wibox')
local gears = require('gears')
local filesystem = require('gears.filesystem')
local iconPath = filesystem.get_configuration_dir() .. '/icons/'

local variables = require("conf.variables")
local widget_battery = require("widgets.battery")
local clickable_container = require("widgets.clickable-container")
local mat_list_item = require('widgets.mat-list-item')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ variables.modkey }, 1, function(t)
      if _G.client.focus then
        _G.client.focus:move_to_tag(t)
      end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ variables.modkey }, 3, function(t)
      if _G.client.focus then
        _G.client.focus:toggle_tag(t)
      end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local arch_icon = wibox.widget {
  image = iconPath .. 'arch.svg',
  widget = wibox.widget.imagebox
}

local LeftPanel = function(s, w, mw)
  local layoutbox = awful.widget.layoutbox(s)
  layoutbox:buttons(gears.table.join(
                      awful.button({ }, 1, function () awful.layout.inc( 1) end),
                      awful.button({ }, 3, function () awful.layout.inc(-1) end),
                      awful.button({ }, 4, function () awful.layout.inc( 1) end),
                      awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  -- Create a taglist widget
  local taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {}, nil,
                                       wibox.layout.fixed.vertical())

  local home_button = wibox.widget {
    wibox.widget {
      wibox.container.margin(arch_icon, dpi(9), dpi(9), dpi(9), dpi(9)),
      widget = clickable_container
    },
    bg = beautiful.panel_bg,
    widget = wibox.container.background
  }

  local panel = wibox {
    screen = s,
    height = s.geometry.height,
    width = w,
    x = s.geometry.x,
    y = s.geometry.y,
    ontop = true,
    bg = beautiful.panel_bg,
    fg = beautiful.fg_normal
  }
  panel:struts({ left = w })
  panel.opened = false

  local backdrop =
    wibox {
      ontop = true,
      screen = s,
      bg = '#000000aa',
      type = 'dock',
      x = s.geometry.x + mw,
      y = s.geometry.y,
      width = s.geometry.width - mw,
      height = s.geometry.height
    }

  home_button:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          panel:toggle()
        end
      )
    )
  )

  local run_rofi =
    function()
      _G.awesome.spawn(
        'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/conf/rofi.rasi',
        false,
        false,
        false,
        false,
        function()
          panel:toggle()
        end
      )
    end

  local openPanel = function(should_run_rofi)
    panel.width = mw
    panel.visible = false
    panel.visible = true
    backdrop.visible = true
    if should_run_rofi then
      run_rofi()
    end
  end

  local closePanel = function()
    panel.visible = true
    panel.width = w
    backdrop.visible = false
  end

  function panel:toggle(should_run_rofi)
    self.opened = not self.opened
    if self.opened then
      openPanel(should_run_rofi)
    else
      if should_run_rofi then
        self.opened = not self.opened
        run_rofi()
      else
        closePanel()
      end
    end
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )

  local search_button =
    wibox.widget {
      wibox.widget {
        wibox.widget {
          image = iconPath .. 'search.svg',
          widget = wibox.widget.imagebox
        },
        margins = dpi(12),
        widget = wibox.container.margin
      },
      wibox.widget {
        text = 'Search Applications',
        widget = wibox.widget.textbox
      },
      clickable = true,
      widget = mat_list_item
    }

  search_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          run_rofi()
        end
      )
    )
  )

  local exit_button =
    wibox.widget {
      wibox.widget {
        wibox.widget {
          image = iconPath .. 'logout.svg',
          widget = wibox.widget.imagebox
        },
        margins = dpi(12),
        widget = wibox.container.margin
      },
      wibox.widget {
        text = 'End work session',
        widget = wibox.widget.textbox
      },
      clickable = true,
      divider = true,
      widget = mat_list_item
    }

  exit_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
          _G.exit_screen_show()
        end
      )
    )
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    {
      {
        layout = wibox.layout.align.vertical,
        {
          layout = wibox.layout.fixed.vertical,
          {
            search_button,
            bg = '#192933',
            widget = wibox.container.background
          },
          wibox.widget {
            orientation = 'horizontal',
            forced_height = 1,
            opacity = 0.08,
            widget = wibox.widget.separator
          },
          require('widgets.quick-settings'),
          require("widgets.hardware-monitor")
        },
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          {
            exit_button,
            bg = '#192933',
            widget = wibox.container.background
          }
        }
      },
      bg = beautiful.panel_bg,
      widget = wibox.container.background
    },
    {
      layout = wibox.layout.align.vertical,
      forced_width = w,
      {
        layout = wibox.layout.fixed.vertical,
        home_button,
        taglist,
      },
      nil,
      {
        widget_battery,
        wibox.container.margin(layoutbox, 4, 4, 4, 4),
        layout = wibox.layout.fixed.vertical,
      },
    }
  }

  return panel
end

return LeftPanel
