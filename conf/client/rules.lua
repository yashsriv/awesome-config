local awful = require('awful')
local beautiful = require('beautiful')

local clientkeys = require('conf.client.keys')
local clientbuttons = require('conf.client.buttons')

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      size_hints_honor = false,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen
    }
  },

  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
      },
      class = {
        "Arandr",
        "mpv",
        "Gimp",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "xtightvncviewer"},

      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
  }, properties = { floating = true }},

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {type = { "dialog" }},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true,
      titlebars_enabled = true
    }
  },

  -- Set Firefox to always map on the tag named "1" on screen 1.
  { rule = { class = "Firefox" },
    properties = { tag = "1" } },
  { rule = { class = "Emacs" },
    properties = { tag = "2" } },
}
-- }}}
