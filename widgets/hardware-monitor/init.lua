local wibox = require('wibox')
local mat_list_item = require('widgets.mat-list-item')

return wibox.widget {
  wibox.widget {
    wibox.widget {
      text = 'Hardware monitor',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widgets.hardware-monitor.cpu-meter'),
  require('widgets.hardware-monitor.ram-meter'),
  require('widgets.hardware-monitor.temperature-meter'),
  layout = wibox.layout.fixed.vertical
}
