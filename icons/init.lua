local filesystem = require('gears.filesystem')
local iconPath = filesystem.get_configuration_dir() .. '/icons/'

local icons = {}

-- Settings icons
icons.mute = iconPath .. 'mute.svg'
icons.volume_up = iconPath .. 'volume_up.svg'
icons.volume_down = iconPath .. 'volume_down.svg'
function icons.volume(value, mute)
  if mute then
    return icons.mute
  end
  if value > 50 then
    return icons.volume_up
  end
  return icons.volume_down
end

icons.brightness_low = iconPath .. 'brightness_low.svg'
icons.brightness_medium = iconPath .. 'brightness_medium.svg'
icons.brightness_high = iconPath .. 'brightness_high.svg'
function icons.brightness(value)
  if value > 75 then
    return icons.brightness_high
  elseif value < 25 then
    return icons.brightness_low
  end
  return icons.brightness_medium
end

-- Power/System Icons
icons.power = iconPath .. 'power.svg'
icons.restart = iconPath .. 'restart.svg'
icons.sleep = iconPath .. 'sleep.svg'
icons.logout = iconPath .. 'logout.svg'
icons.lock = iconPath .. 'lock.svg'

-- Tag icons
icons.firefox = iconPath .. 'firefox.png'
icons.spacemacs = iconPath .. 'spacemacs.svg'
icons.terminal = iconPath .. 'terminal.svg'
function icons.project(value)
  return iconPath .. 'project-' .. value .. '.svg'
end

-- Panel icons
icons.home = iconPath .. 'arch.svg'
icons.search = iconPath .. 'search.svg'

-- Hardware icons
icons.cpu = iconPath .. 'chart.svg'
icons.ram = iconPath .. 'memory.svg'
icons.temperature = iconPath .. 'thermometer.svg'

-- Battery Icons
icons.unknown_battery = iconPath .. 'battery/battery_unknown.svg'
function icons.battery(value, charging)
  if charging then
    if value == 100 then
      return iconPath .. 'battery/battery_charging_full.svg'
    elseif value > 90 then
      return iconPath .. 'battery/battery_charging_90.svg'
    elseif value > 80 then
      return iconPath .. 'battery/battery_charging_80.svg'
    elseif value > 60 then
      return iconPath .. 'battery/battery_charging_60.svg'
    elseif value > 50 then
      return iconPath .. 'battery/battery_charging_50.svg'
    elseif value > 30 then
      return iconPath .. 'battery/battery_charging_30.svg'
    end
    return iconPath .. 'battery/battery_charging_20.svg'
  else
    if value == 100 then
      return iconPath .. 'battery/battery_full.svg'
    elseif value > 90 then
      return iconPath .. 'battery/battery_90.svg'
    elseif value > 80 then
      return iconPath .. 'battery/battery_80.svg'
    elseif value > 60 then
      return iconPath .. 'battery/battery_60.svg'
    elseif value > 50 then
      return iconPath .. 'battery/battery_50.svg'
    elseif value > 30 then
      return iconPath .. 'battery/battery_30.svg'
    elseif value > 20 then
      return iconPath .. 'battery/battery_20.svg'
    end
    return iconPath .. 'battery/battery_alert.svg'
  end
end

return icons
