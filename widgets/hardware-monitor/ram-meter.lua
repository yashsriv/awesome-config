-- Global modules
local dpi = require('beautiful').xresources.apply_dpi
local vicious = require("vicious")
local watch = require('awful.widget.watch')
local wibox = require('wibox')

-- Local modules
local mat_slider = require('widgets.mat-slider')
local icons = require('icons')

local slider =
  wibox.widget {
    read_only = true,
    widget = mat_slider
  }

local mem_text = wibox.widget.textbox()

-- vicious.cache(vicious.widgets.mem)
vicious.register(mem_text, vicious.widgets.mem,
                 function(_, args)
                   local value = tonumber(string.format("%i", math.floor(tonumber(args[2]) / 100))) / 10
                   return string.format("<span foreground=\"white\">%gG</span>", value)
                 end, 13)

watch(
  'bash -c "free | grep -z Mem.*Swap.*"',
  1,
  function(_, stdout, _, _, _)
    local total,
    used,
    _,
    _,
    _,
    _,
    _,
    _,
    _ = stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')
    slider:set_value(used / total * 100)
    collectgarbage('collect')
  end
)

local ram_meter =
  wibox.widget {
    wibox.widget {
      wibox.widget {
        image = icons.ram,
        forced_height = dpi(24),
        forced_width = dpi(24),
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
      mem_text,
      left = dpi(12),
      widget = wibox.container.margin
    },
    forced_height = dpi(40),
    layout = wibox.layout.align.horizontal
  }

return ram_meter
