-- Global modules
local dpi = require('beautiful').xresources.apply_dpi
local spawn = require('awful.spawn')
local watch = require('awful.widget.watch')
local wibox = require('wibox')

-- Local modules
local icons = require('icons')
local mat_list_item = require('widgets.mat-list-item')
local mat_slider = require('widgets.mat-slider')

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
  image = icons.brightness(50),
  widget = wibox.widget.imagebox
}

watch(
  [[bash -c "light -G"]],
  1,
  function(_, stdout, _, _, _)
    local bright, decimal = string.match(stdout, '(%d+).(%d+)')
    local bright_num = tonumber(bright) + 0.01 * tonumber(decimal)
    slider:set_value(bright_num)
    icon.image = icons.brightness(bright_num)
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
