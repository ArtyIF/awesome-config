local awful = require("awful")
local gears = require("gears")
local modkeys = require("components.keybinds.modkeys")

local this = {}

this.group_name = "Screenshot (Spectacle)"
this.keybinds = gears.table.join(
    awful.key({                              }, "Print", function() awful.spawn.with_shell("spectacle --background --pointer --copy-image --current; copyq select 0") end, { description="Screenshot Current Screen", group=this.group_name }),
    awful.key({ modkeys.alt                  }, "Print", function() awful.spawn.with_shell("spectacle --background --pointer --copy-image --activewindow; copyq select 0") end, { description="Screenshot Focused Window", group=this.group_name }),
    awful.key({ modkeys.shift, modkeys.super }, "s", function() awful.spawn.with_shell("spectacle --background --pointer --copy-image --region; copyq select 0") end, { description="(screen snip button) Screenshot Rectangular Region", group=this.group_name })
)

function this.connect_keybinds(keybinds_dict)
    return gears.table.join(keybinds_dict, this.keybinds)
end

return this
