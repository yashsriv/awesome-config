local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local mat_list_item = require('widgets.mat-list-item')
local mat_slider = require('widgets.mat-slider')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')
local dpi = require('beautiful').xresources.apply_dpi

local icons = require('icons')
local clickable_container = require('widgets.clickable-container')
local slider =
  wibox.widget {
  read_only = false,
  widget = mat_slider
}

slider:connect_signal(
  'property::value',
  function()
    spawn('pulseaudio-ctl set ' .. slider.value)
  end
)

local icon =
  wibox.widget {
  image = icons.volume(0, true),
  widget = wibox.widget.imagebox
}

watch(
  [[bash -c "pulseaudio-ctl full-status"]],
  1,
  function(_, stdout, _, _, _)
    local volume, mute, _ = string.match(stdout, '(%d+)%s(%a+)%s(%a+)')
    local volume_num = tonumber(volume)
    slider:set_value(volume_num)
    icon.image = icons.volume(volume_num, mute == "yes")
    collectgarbage('collect')
  end
)

local button = wibox.widget {
  wibox.container.margin(icon, dpi(12), dpi(12), dpi(12), dpi(12)),
  shape = gears.shape.circle,
  widget = clickable_container
}

button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn("pulseaudio-ctl mute")
        icon.image = icons.volume(slider.value, not icon.image == icons.mute)
      end
    )
  )
)

local volume_setting =
  wibox.widget {
  button,
  slider,
  widget = mat_list_item
}

return volume_setting
