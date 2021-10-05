local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local gears = require("gears")
local modkeys = require("components.keybinds.modkeys")

local this = {}

this.group_name = "Window"
-- todo: add more keybinds?
this.keybinds = gears.table.join(
    awful.key({ modkeys.super }, "f", function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "Toggle Fullscreen", group = this.group_name }),
    awful.key({ modkeys.alt }, "F4", function (c) c:kill() end, { description = "Close", group = this.group_name }),
    awful.key({ modkeys.super }, "Down", function (c)
            if c.maximized == true then
                c.maximized = false
                c:raise()
            else
                c.minimized = true
            end
        end, {description = "Restore or Minimize", group = this.group_name}),
    awful.key({ modkeys.super }, "Up",
        function (c)
            -- todo: somehow also let unminimize windows
            c.maximized = true
            c:raise()
        end, { description = "Maximize", group = this.group_name})
)

function this.connect_keybinds(keybinds_dict)
    return gears.table.join(keybinds_dict, this.keybinds)
end

return this