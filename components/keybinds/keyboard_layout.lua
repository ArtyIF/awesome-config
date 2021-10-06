local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local modkeys = require("components.keybinds.modkeys")

local this = {}

this.group_name = "Keyboard Layout"
this.keybinds = gears.table.join(
    awful.key({ modkeys.super }, "space", function()
        KEYBOARD_LAYOUT.next_layout()
        naughty.notification({title = "Layout switched", text = KEYBOARD_LAYOUT._layout[KEYBOARD_LAYOUT._current+1] })
    end, { description = "Next Keyboard Layout", group = this.group_name })
)

function this.connect_keybinds(keybinds_dict)
    return gears.table.join(keybinds_dict, this.keybinds)
end

return this