local wibox = require('wibox')
local mat_list_item = require('widgets.mat-list-item')
local mat_slider = require('widgets.mat-slider')
local filesystem = require('gears.filesystem')
local iconPath = filesystem.get_configuration_dir() .. '/icons/'
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')
local dpi = require('beautiful').xresources.apply_dpi

local slider =
  wibox.widget {
  read_only = false,
  widget = mat_slider
}

slider:connect_signal(
  'property::value',
  function()
    spawn('light -S ' .. slider.value)
  end
)

local icon =
  wibox.widget {
  image = iconPath .. 'brightness_low.svg',
  widget = wibox.widget.imagebox
}

watch(
  [[bash -c "light -G"]],
  1,
  function(_, stdout, _, _, _)
    local bright, decimal = string.match(stdout, '(%d+).(%d+)')
    local bright_num = tonumber(bright) + 0.01 * tonumber(decimal)
    slider:set_value(bright_num)
    if bright_num > 75 then
      icon.image = iconPath .. 'brightness_high.svg'
    else
      if bright_num < 25 then
        icon.image = iconPath .. 'brightness_low.svg'
      else
        icon.image = iconPath .. 'brightness_medium.svg'
      end
    end
    collectgarbage('collect')
  end
)

-- local button = mat_icon_button(icon)

local bright_setting =
  wibox.widget {
  wibox.container.margin(icon, dpi(12), dpi(12), dpi(12), dpi(12)),
  slider,
  widget = mat_list_item
}

return bright_setting
