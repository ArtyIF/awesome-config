local awful = require("awful")
local gears = require("gears")

local this = {}

this.group_name = "Sound"
-- todo: make a global collection of widgets or something
this.keybinds = gears.table.join(
    awful.key({ }, "XF86AudioRaiseVolume", function() VOLUME_CONTROL.up() end, { description="Volume Up", group=this.group_name }),
    awful.key({ }, "XF86AudioLowerVolume", function() VOLUME_CONTROL.down() end, { description="Volume Down", group=this.group_name }),
    awful.key({ }, "XF86AudioMute", function() VOLUME_CONTROL.toggle() end, { description="Toggle Mute", group=this.group_name }),
    awful.key({ }, "XF86AudioPlay", function () awful.spawn.spawn("playerctl play-pause", false) end, { description="Play/Pause", group=this.group_name }),
    awful.key({ }, "XF86AudioPrev", function () awful.spawn.spawn("playerctl previous", false) end, { description="Previous Track", group=this.group_name }),
    awful.key({ }, "XF86AudioNext", function () awful.spawn.spawn("playerctl next", false) end, { description="Next Track", group=this.group_name })
)

function this.connect_keybinds(keybinds_dict)
    return gears.table.join(keybinds_dict, this.keybinds)
end

return this