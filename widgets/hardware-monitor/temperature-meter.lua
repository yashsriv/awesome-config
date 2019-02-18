local wibox = require('wibox')
local mat_slider = require('widgets.mat-slider')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi
local vicious = require("vicious")
local filesystem = require('gears.filesystem')
local iconPath = filesystem.get_configuration_dir() .. '/icons/'

local slider =
  wibox.widget {
    read_only = true,
    widget = mat_slider
  }

local temp_text = wibox.widget.textbox()

vicious.register(temp_text, vicious.widgets.thermal,
                 "<span foreground=\"white\">$1&#xb0;C</span>", 13, "thermal_zone0")

local max_temp = 80
watch(
  'bash -c "cat /sys/class/thermal/thermal_zone0/temp"',
  1,
  function(_, stdout, _, _, _)
    local temp = stdout:match('(%d+)')
    slider:set_value((temp / 1000) / max_temp * 100)
    collectgarbage('collect')
  end
)

local temperature_meter =
  wibox.widget {
    wibox.widget {
      wibox.widget {
        image = iconPath .. "thermometer.svg",
        widget = wibox.widget.imagebox
      },
      left = dpi(9),
      right = dpi(9),
      top = dpi(12),
      bottom = dpi(12),
      widget = wibox.container.margin
    },
    slider,
    wibox.widget {
      temp_text,
      left = dpi(12),
      widget = wibox.container.margin
    },
    forced_height = dpi(40),
    layout = wibox.layout.align.horizontal
  }

return temperature_meter
