local awful = require("awful")
local gears = require("gears")

local this = {}

this.group_name = "sound"
-- todo: make a global collection of widgets or something
this.keybinds = gears.table.join(
    awful.key({ }, "XF86AudioRaiseVolume", function() VOLUME_CONTROL.up() end, { description="increase sound volume", group=this.group_name }),
    awful.key({ }, "XF86AudioLowerVolume", function() VOLUME_CONTROL.down() end, { description="decrease sound volume", group=this.group_name }),
    awful.key({ }, "XF86AudioMute", function() VOLUME_CONTROL.toggle() end, { description="toggle mute sound", group=this.group_name })
)

function this.connect_keybinds(keybinds_dict)
    return gears.table.join(keybinds_dict, this.keybinds)
end

return this