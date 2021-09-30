local awful = require("awful")
local gears = require("gears")
local modkeys = require("components.keybinds.modkeys")

local this = {}

this.group_name = "screenshots (spectacle)"
this.keybinds = gears.table.join(
    awful.key({                              }, "Print", function() awful.spawn.with_shell("spectacle --background --pointer --copy-image --current; copyq select 0") end, { description="screenshot current screen", group=this.group_name }),
    awful.key({ modkeys.alt                  }, "Print", function() awful.spawn.with_shell("spectacle --background --pointer --copy-image --activewindow; copyq select 0") end, { description="screenshot focused window", group=this.group_name }),
    awful.key({ modkeys.shift, modkeys.super }, "s", function() awful.spawn.with_shell("spectacle --background --pointer --copy-image --region; copyq select 0") end, { description="(screen snip button on Microsoft keyboards) screenshot rectangular region", group=this.group_name })
)

function this.connect_keybinds(keybinds_dict)
    return gears.table.join(keybinds_dict, this.keybinds)
end

return this
