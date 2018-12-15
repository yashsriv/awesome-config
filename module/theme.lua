--
-- Themes define colours, icons, and wallpapers
--

local beautiful = require("beautiful")
local awful  = require("awful")
local variables = require("conf.variables")
local gears  = require("gears")
local screen = screen

-- | Theme | --
beautiful.init(gears.filesystem.get_themes_dir() .. variables.theme .. "/theme.lua")
beautiful.get().wallpaper = variables.wallpaper
beautiful.get().font = variables.font
-- beautiful.get().wibar_ontop = true
