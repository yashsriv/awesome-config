local wibox = require('wibox')
local mat_list_item = require('widgets.mat-list-item')

return wibox.widget {
  wibox.widget {
    wibox.widget {
      text = 'Quick settings',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widgets.quick-settings.volume-setting'),
  require('widgets.quick-settings.brightness-setting'),
  layout = wibox.layout.fixed.vertical
}
