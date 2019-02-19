-- Global modules
local awful = require('awful')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears')
local filesystem = require('gears.filesystem')
local wibox = require('wibox')

-- Local modules
local variables = require("conf.variables")
local icons = require('icons')
local clickable_container = require("widgets.clickable-container")
local mat_list_item = require('widgets.mat-list-item')
local widget_battery = require("widgets.battery")

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

local home_icon = wibox.widget {
  image = icons.home,
  widget = wibox.widget.imagebox
}

local LeftPanel = function(s, w, mw)
  local systray = wibox.widget.systray()
  systray:set_horizontal(false)

  -- Create a taglist widget
  local taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {}, nil,
                                       wibox.layout.fixed.vertical())

  local home_button = wibox.widget {
    wibox.widget {
      wibox.container.margin(home_icon, dpi(9), dpi(9), dpi(9), dpi(9)),
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

  local exit_screen_grabber = nil

  local run_rofi =
    function()
      if exit_screen_grabber then
        awful.keygrabber.stop(exit_screen_grabber)
        exit_screen_grabber = nil
      end
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
    else
      exit_screen_grabber =
        awful.keygrabber.run(
          function(_, key, event)
            if event == 'release' then
              return
            end

            if key == 'Escape' or key == 'q' or key == 'x'
              or key == 'p' then
              panel:toggle()
            elseif key == 'd' then
              awful.keygrabber.stop(exit_screen_grabber)
              exit_screen_grabber = nil
              run_rofi()
            else
              return false
            end
          end
        )
    end
  end

  local closePanel = function()
    panel.visible = true
    panel.width = w
    backdrop.visible = false
    if exit_screen_grabber then
      awful.keygrabber.stop(exit_screen_grabber)
      exit_screen_grabber = nil
    end
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
          image = icons.search,
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
          image = icons.logout,
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
        layout = wibox.layout.fixed.vertical,
        wibox.container.margin(systray, dpi(7), dpi(7), dpi(7), dpi(7)),
        widget_battery,
      },
    }
  }

  return panel
end

return LeftPanel
