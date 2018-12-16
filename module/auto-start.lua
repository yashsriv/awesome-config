local awful = require('awful')

-- {{{ Startup
os.execute("compton -b")
os.execute("xset r rate 200 60")
-- awful.util.spawn_with_shell('/home/yash/bin/locker.sh')
awful.spawn.with_shell("/home/yash/.config/awesome/autorun.sh")
-- }}}
