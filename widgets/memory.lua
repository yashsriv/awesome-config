local wibox = require("wibox")
local vicious = require("vicious")
memwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, "($2MB/$3MB) ", 13)
return memwidget
