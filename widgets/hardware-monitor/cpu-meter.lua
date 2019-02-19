-- Global modules
local dpi = require('beautiful').xresources.apply_dpi
local vicious = require("vicious")
local watch = require('awful.widget.watch')
local wibox = require('wibox')

-- Local Modules
local icons = require('icons')
local mat_slider = require('widgets.mat-slider')

local total_prev = 0
local idle_prev = 0

local slider =
  wibox.widget {
    read_only = true,
    widget = mat_slider
  }

local cpu_text = wibox.widget.textbox()


local	function lpad(s, l, c)
  local res = string.rep(c or ' ', l - #s) .. s

  return res, res ~= s
end
-- vicious.cache(vicious.widgets.mem)
vicious.register(cpu_text, vicious.widgets.cpu,
                 function (_, args)
                   return "<span foreground=\"white\">" .. lpad(tostring(args[1]), 3) .. "%</span>"
                 end, 1)



watch(
  [[bash -c "cat /proc/stat | grep '^cpu '"]],
  1,
  function(_, stdout, _, _, _)
    local user,
    nice,
    system,
    idle,
    iowait,
    irq,
    softirq,
    steal,
    _,
    _ = stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    slider:set_value(diff_usage)

    total_prev = total
    idle_prev = idle
    collectgarbage('collect')
  end
)

local cpu_meter =
  wibox.widget {
    wibox.widget {
      wibox.widget {
        image = icons.cpu,
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
      cpu_text,
      left = dpi(12),
      widget = wibox.container.margin
    },
    forced_height = dpi(40),
    layout = wibox.layout.align.horizontal
  }

return cpu_meter
