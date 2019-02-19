-- Global Modules
local awful = require('awful')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears')
local wibox = require('wibox')

-- Local Modules
local clickable_container = require('widgets.clickable-container')
local icons = require('icons')

-- Appearance
local icon_size = beautiful.exit_screen_icon_size or dpi(140)

local buildButton =
  function(icon, tooltipText)
    local abutton =
      wibox.widget {
        wibox.widget {
          wibox.widget {
            wibox.widget {
              image = icon,
              widget = wibox.widget.imagebox
            },
            top = dpi(16),
            bottom = dpi(16),
            left = dpi(16),
            right = dpi(16),
            widget = wibox.container.margin
          },
          shape = gears.shape.circle,
          forced_width = icon_size,
          forced_height = icon_size,
          widget = clickable_container
        },
        left = dpi(24),
        right = dpi(24),
        widget = wibox.container.margin
      }

    awful.tooltip({
        objects = {abutton},
        mode = "outside",
        preferred_positions = {"bottom", "top", "right", "left"},
        preferred_alignments = {"middle", "front", "back"},
        timer_function = function()
          return tooltipText
        end,
        margin_leftright = dpi(8),
        margin_topbottom = dpi(8)
    })

    return abutton
  end

local exit_screen_grabber

local function suspend_command()
  _G.exit_screen_hide()
  awful.spawn.with_shell('systemctl suspend')
end

local function exit_command()
  _G.awesome.quit()
end

local function lock_command()
  _G.exit_screen_hide()
  awful.util.spawn("sync")
  awful.util.spawn("xautolock -locknow")
end

local function poweroff_command()
  awful.spawn.with_shell('systemctl poweroff')
  awful.keygrabber.stop(exit_screen_grabber)
end

local function reboot_command()
  awful.spawn.with_shell('systemctl reboot')
  awful.keygrabber.stop(exit_screen_grabber)
end

local poweroff = buildButton(icons.power, 'Shutdown')
poweroff:connect_signal(
  'button::release',
  function()
    poweroff_command()
  end
)

local reboot = buildButton(icons.restart, 'Restart')
reboot:connect_signal(
  'button::release',
  function()
    reboot_command()
  end
)

local suspend = buildButton(icons.sleep, 'Sleep')
suspend:connect_signal(
  'button::release',
  function()
    suspend_command()
  end
)

local exit = buildButton(icons.logout, 'Logout')
exit:connect_signal(
  'button::release',
  function()
    exit_command()
  end
)

local lock = buildButton(icons.lock, 'Lock')
lock:connect_signal(
  'button::release',
  function()
    lock_command()
  end
)

-- Get screen geometry
local screen_geometry = awful.screen.focused().geometry

-- Create the widget
local exit_screen =
  wibox(
  {
    x = screen_geometry.x,
    y = screen_geometry.y,
    visible = false,
    ontop = true,
    type = 'splash',
    height = screen_geometry.height,
    width = screen_geometry.width
  }
)

exit_screen.bg = '#192933dd'
exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or '#FEFEFE'

function _G.exit_screen_hide()
  awful.keygrabber.stop(exit_screen_grabber)
  exit_screen.visible = false
end

function _G.exit_screen_show()
  -- naughty.notify({text = "starting the keygrabber"})
  exit_screen_grabber =
    awful.keygrabber.run(
    function(_, key, event)
      if event == 'release' then
        return
      end

      if key == 's' then
        suspend_command()
      elseif key == 'e' then
        exit_command()
      elseif key == 'l' then
        lock_command()
      elseif key == 'p' then
        poweroff_command()
      elseif key == 'r' then
        reboot_command()
      elseif key == 'Escape' or key == 'q' or key == 'x' then
        -- naughty.notify({text = "Cancel"})
        _G.exit_screen_hide()
      -- else awful.keygrabber.stop(exit_screen_grabber)
      end
    end
  )
  exit_screen.visible = true
end

exit_screen:buttons(
  gears.table.join(
    -- Middle click - Hide exit_screen
    awful.button(
      {},
      2,
      function()
        _G.exit_screen_hide()
      end
    ),
    -- Right click - Hide exit_screen
    awful.button(
      {},
      3,
      function()
        _G.exit_screen_hide()
      end
    )
  )
)

-- Item placement
exit_screen:setup {
  nil,
  {
    nil,
    {
      -- {
      poweroff,
      reboot,
      suspend,
      exit,
      lock,
      layout = wibox.layout.fixed.horizontal
      -- },
      -- widget = exit_screen_box
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.horizontal
  },
  nil,
  expand = 'none',
  layout = wibox.layout.align.vertical
}
